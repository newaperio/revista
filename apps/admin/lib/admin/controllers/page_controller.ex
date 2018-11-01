defmodule Admin.PageController do
  use Admin, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
