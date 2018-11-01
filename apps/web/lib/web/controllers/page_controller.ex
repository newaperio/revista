defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    posts = CMS.Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end
end
