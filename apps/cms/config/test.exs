use Mix.Config

config :logger, level: :warn

config :cms, CMS.Repo,
  database: "cms_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
