# Since configuration is shared in umbrella projects, this file
# should only configure the :web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :web,
  generators: [context_app: false]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/2JcTUZjaYsxZMihog0fd47SCgXPa90BLF7hR+GfpZOeL5XcOTqT/oQ0OXkYknmL",
  render_errors: [view: Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
