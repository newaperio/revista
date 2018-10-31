defmodule Auth do
  @moduledoc """
  Authentication system for the platform.
  """

  alias Auth.Repo
  alias Auth.Account

  def register(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def login(email, password) do
    account = Repo.get_by(Account, email: email)
    do_login(account, password)
  end

  defp do_login(%Account{password_hash: password_hash} = account, password) do
    if Comeonin.Argon2.checkpw(password, password_hash) do
      {:ok, account}
    else
      {:error, :unauthorized}
    end
  end

  defp do_login(nil, _) do
    Comeonin.Argon2.dummy_checkpw()
    {:error, :not_found}
  end
end
