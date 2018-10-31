use Mix.Config

config :auth, Auth.Repo,
  database: "auth_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
