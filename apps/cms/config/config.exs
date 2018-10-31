use Mix.Config

# Set default logging level
config :logger, level: :debug

# Set the Ecto repo
config :cms, ecto_repos: [CMS.Repo]

# Import environment specific config
import_config "#{Mix.env()}.exs"
