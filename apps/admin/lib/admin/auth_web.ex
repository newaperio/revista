defmodule Admin.AuthWeb do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Auth.get_user!(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, email, password) do
    case Auth.authenticate(email, password) do
      {:ok, user} ->
        {:ok, put_user(conn, user)}

      result ->
        IO.inspect(result)
        Tuple.append(result, conn)
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  defp put_user(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
