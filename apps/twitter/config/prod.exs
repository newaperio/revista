use Mix.Config

config :twitter, Twitter.Endpoint,
  server: true,
  root: ".",
  version: Application.spec(:twitter, :vsn)
