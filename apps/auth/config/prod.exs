use Mix.Config

config :logger, level: :info

config :auth, Auth.Repo,
  database: "auth_prod",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 10
