use Mix.Config

config :cms, CMS.Repo,
  database: "cms_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
