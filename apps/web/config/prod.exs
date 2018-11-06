use Mix.Config

config :web, Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:web, :vsn)
