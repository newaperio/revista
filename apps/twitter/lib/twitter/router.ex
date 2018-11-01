defmodule Twitter.Router do
  use Twitter, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Twitter do
    pipe_through :api
  end
end
