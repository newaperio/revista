use Mix.Config

config :admin, Admin.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:admin, :vsn)
