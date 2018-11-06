defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", Web do
    pipe_through(:browser)

    get("/", PageController, :index)

    forward("/", PlugRouter)
  end
end
