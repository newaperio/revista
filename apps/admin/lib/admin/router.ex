defmodule Admin.Router do
  use Admin, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Admin.AuthWeb)
  end

  scope "/", Admin do
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/posts", PostController)
    resources("/users", UserController, only: [:new, :create])
    resources("/sessions", SessionController, only: [:new, :create, :delete])

    forward("/", PlugRouter)
  end
end
