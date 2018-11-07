use Mix.Config

defmodule Revista.ConfigHelpers do
  @moduledoc false

  def integer_var(varname, default \\ 1) do
    case System.get_env(varname) do
      nil -> default
      val -> String.to_integer(val)
    end
  end
end

alias Revista.ConfigHelpers

# Set Configuration

admin = %{
  port: ConfigHelpers.integer_var("ADMIN_PORT", 4001),
  secret_key_base: System.get_env("ADMIN_SECRET_KEY_BASE")
}

auth = %{
  pool_size: ConfigHelpers.integer_var("AUTH_POOL_SIZE", 10),
  database_url: System.get_env("AUTH_DATABASE_URL")
}

cms = %{
  pool_size: ConfigHelpers.integer_var("CMS_POOL_SIZE", 10),
  database_url: System.get_env("CMS_DATABASE_URL")
}

proxy = %{
  port: ConfigHelpers.integer_var("PROXY_PORT", 4000)
}

twitter = %{
  bearer_token: System.get_env("TWITTER_BEARER_TOKEN"),
  port: ConfigHelpers.integer_var("TWITTER_PORT", 4002),
  screen_name: System.get_env("TWITTER_SCREEN_NAME"),
  secret_key_base: System.get_env("TWITTER_SECRET_KEY_BASE")
}

web = %{
  port: ConfigHelpers.integer_var("WEB_PORT", 4003),
  secret_key_base: System.get_env("WEB_SECRET_KEY_BASE")
}

# Apply Configuration

config :admin, Admin.Endpoint,
  http: [:inet6, port: admin[:port]],
  url: [host: "localhost", port: admin[:port]],
  secret_key_base: admin[:secret_key_base]

config :auth, Auth.Repo,
  url: auth[:database_url],
  pool_size: auth[:pool_size]

config :cms, CMS.Repo,
  url: cms[:database_url],
  pool_size: cms[:pool_size]

config :proxy,
  port: proxy[:port]

config :twitter, Twitter.Endpoint,
  http: [:inet6, port: twitter[:port]],
  url: [host: "localhost", port: twitter[:port]],
  secret_key_base: twitter[:secret_key_base]

config :twitter, Twitter.HTTPClient,
  bearer_token: twitter[:bearer_token],
  screen_name: twitter[:screen_name]

config :admin, Web.Endpoint,
  http: [:inet6, port: web[:port]],
  url: [host: "localhost", port: web[:port]],
  secret_key_base: web[:secret_key_base]
