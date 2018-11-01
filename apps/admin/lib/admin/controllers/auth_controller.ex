defmodule Admin.AuthController do
  use Admin, :controller

  def authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You aren’t authorized to access this page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
