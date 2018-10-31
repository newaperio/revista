use Mix.Config

# General application configuration
config :admin,
  namespace: Admin,
  generators: [context_app: false]

# Configures the endpoint
config :admin, Admin.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "PjgTIyB/MD+MOki658QKj7/N2KlaUIg0dme/HNzFenZJd+VKf+oO2jnWW9bGo4r4",
  render_errors: [view: Admin.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Admin.PubSub, adapter: Phoenix.PubSub.PG2]

# Use Jason as Phoenix's JSON library
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
