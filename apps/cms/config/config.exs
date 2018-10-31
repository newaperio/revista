use Mix.Config

config :logger, level: :debug

config :cms, ecto_repos: [CMS.Repo]

import_config "#{Mix.env()}.exs"
