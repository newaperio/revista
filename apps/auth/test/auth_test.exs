defmodule AuthTest do
  use ExUnit.Case

  @valid_attrs %{email: "alice@example.com", password: "password"}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo)
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Auth.register()

    user
  end

  test "register/1 with valid data succeeds" do
    assert {:ok, user} = Auth.register(%{email: "alice@example.com", password: "password"})
    assert user.email == "alice@example.com"
    assert Comeonin.Argon2.checkpw("password", user.password_hash)
  end

  test "register/1 with invalid returns error changeset" do
    user = user_fixture()

    {:error, _} = Auth.register(%{email: user.email, password: "password"})

    {:error, _} = Auth.register(%{email: "", password: "password"})
    {:error, _} = Auth.register(%{email: "bobexample.com", password: "password"})

    {:error, _} = Auth.register(%{email: "bob@example.com", password: ""})
    {:error, _} = Auth.register(%{email: "bob@example.com", password: "pass"})
  end

  test "authenticate/2 with valid data succeeds" do
    user = user_fixture()
    id = user.id
    assert {:ok, %{id: ^id}} = Auth.authenticate(user.email, user.password)
  end

  test "authenticate/2 with invalid data fails" do
    user = user_fixture()
    assert {:error, :unauthorized} = Auth.authenticate(user.email, user.password <> "!")
    assert {:error, :not_found} = Auth.authenticate(user.email <> "!", user.password)
  end
end
