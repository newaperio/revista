defmodule Auth do
  @moduledoc """
  Authentication system for the platform.
  """

  alias Auth.Repo
  alias Auth.User

  def get_user!(id), do: Repo.get!(User, id)

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Comeonin.Argon2.checkpw(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, :not_found}
    end
  end
end
