use Mix.Config

config :cms_web,
  namespace: CMSWeb,
  generators: [context_app: false]

config :cms_web, CMSWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PjgTIyB/MD+MOki658QKj7/N2KlaUIg0dme/HNzFenZJd+VKf+oO2jnWW9bGo4r4",
  render_errors: [view: CMSWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CMSWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
