defmodule CMSWeb.PageController do
  use CMSWeb, :controller

  def index(conn, _params) do
    posts = CMS.Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end
end
