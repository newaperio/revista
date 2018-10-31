defmodule AuthTest do
  use ExUnit.Case

  @valid_attrs %{email: "alice@example.com", password: "password"}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo)
  end

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Auth.register()

    account
  end

  test "register/1 with valid data succeeds" do
    assert {:ok, account} = Auth.register(%{email: "alice@example.com", password: "password"})
    assert account.email == "alice@example.com"
    assert Comeonin.Argon2.checkpw("password", account.password_hash)
  end

  test "register/1 with invalid returns error changeset" do
    account = account_fixture()

    {:error, _} = Auth.register(%{email: account.email, password: "password"})

    {:error, _} = Auth.register(%{email: "", password: "password"})
    {:error, _} = Auth.register(%{email: "bobexample.com", password: "password"})

    {:error, _} = Auth.register(%{email: "bob@example.com", password: ""})
    {:error, _} = Auth.register(%{email: "bob@example.com", password: "pass"})
  end

  test "login/2 with valid data succeeds" do
    account = account_fixture()
    id = account.id
    assert {:ok, %{id: ^id}} = Auth.login(account.email, account.password)
  end

  test "login/2 with invalid data fails" do
    account = account_fixture()
    assert {:error, :unauthorized} = Auth.login(account.email, account.password <> "!")
    assert {:error, :not_found} = Auth.login(account.email <> "!", account.password)
  end
end
