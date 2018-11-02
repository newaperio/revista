use Mix.Config

config :twitter, Twitter.Endpoint,
  http: [port: System.get_env("PORT") || 4002],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
