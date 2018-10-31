defmodule Admin.Router do
  use Admin, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Admin do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController
  end
end
