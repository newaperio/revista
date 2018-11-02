use Mix.Config

config :logger, level: :info

config :cms, CMS.Repo,
  database: "cms_prod",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 10
