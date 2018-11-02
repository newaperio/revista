defmodule Admin.PostView do
  use Admin, :view

  def post_body_html(conn) do
    if conn.assigns[:post], do: conn.assigns[:post].body
  end

  def post_cancel_path(conn) do
    if conn.assigns[:post] do
      Routes.post_path(conn, :show, conn.assigns[:post])
    else
      Routes.post_path(conn, :index)
    end
  end
end
