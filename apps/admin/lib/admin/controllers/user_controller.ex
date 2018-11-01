defmodule Admin.UserController do
  use Admin, :controller

  def new(conn, _) do
    changeset = Auth.change_user()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.register(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.email} created!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> Admin.AuthWeb.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
