use Mix.Config

config :logger, level: :info

config :auth, Auth.Repo,
  database: "auth_prod",
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
