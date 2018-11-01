defmodule Admin.SessionController do
  use Admin, :controller

  alias Admin.AuthWeb

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case AuthWeb.login(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Sorry, those crendentials are invalid.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> AuthWeb.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
