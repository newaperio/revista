# Since configuration is shared in umbrella projects, this file
# should only configure the :twitter application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :twitter,
  generators: [context_app: false]

# Configures the endpoint
config :twitter, Twitter.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LPVoRt3YEO9+37Xaa6nQxp6Lxnipl1xieg8RiQrv1loYF0GERVlktSlHo5WArzdD",
  render_errors: [view: Twitter.ErrorView, accepts: ~w(json)],
  pubsub: [name: Twitter.PubSub, adapter: Phoenix.PubSub.PG2]

config :twitter,
  client: Twitter.HTTPClient

config :twitter, Twitter.HTTPClient,
  bearer_token: System.get_env("BEARER_TOKEN"),
  screen_name: System.get_env("SCREEN_NAME")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
