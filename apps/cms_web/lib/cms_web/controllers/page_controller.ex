defmodule CMSWeb.PageController do
  use CMSWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
