use Mix.Config

config :auth, Auth.Repo,
  database: "auth_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

# Set default logging level
config :logger, level: :debug

# Set the Ecto repo
config :auth, ecto_repos: [Auth.Repo]

# Import environment specific config
import_config "#{Mix.env()}.exs"
