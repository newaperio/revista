defmodule Twitter.Router do
  use Twitter, :router

  pipeline :api do
    plug(Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison
    )
  end

  scope "/" do
    forward("/healthcheck", Twitter.PlugRouter)
    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: Twitter.Schema)
    forward("/", Absinthe.Plug, schema: Twitter.Schema)
  end
end
