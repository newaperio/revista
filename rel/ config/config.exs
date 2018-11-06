use Mix.Config

admin = %{
  port: String.to_integer(System.get_env("ADMIN_PORT")),
  secret_key_base: System.get_env("ADMIN_SECRET_KEY_BASE")
}

auth = %{
  pool_size: String.to_integer(System.get_env("AUTH_POOL_SIZE")),
  database_url: System.get_env("AUTH_DATABASE_URL")
}


cms = %{
  pool_size: String.to_integer(System.get_env("CMS_POOL_SIZE")),
  database_url: System.get_env("CMS_DATABASE_URL")
}

twitter = %{
  bearer_token: System.get_env("TWITTER_BEARER_TOKEN"),
  port: String.to_integer(System.get_env("TWITTER_PORT"))
  screen_name: System.get_env("TWITTER_SCREEN_NAME")
  secret_key_base: System.get_env("TWITTER_SECRET_KEY_BASE")
}

web = %{
  port: String.to_integer(System.get_env("WEB_PORT")),
  secret_key_base: System.get_env("WEB_SECRET_KEY_BASE")
}

# Configuration

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

twitter_port = String.to_integer(System.get_env("TWITTER_PORT"))
config :admin, Twitter.Endpoint,
  http: [:inet6, port: twitter[:port]],
  url: [host: "localhost", port: twitter[:port]],
  secret_key_base: twitter[:secret_key_base]

config :twitter, Twitter.HTTPClient,
  bearer_token: twitter[:bearer_token],
  screen_name: twitter[:screen_name]

web_port = String.to_integer(System.get_env("WEB_PORT"))
config :admin, Web.Endpoint,
  http: [:inet6, port: web[:port]],
  url: [host: "localhost", port: web[:port]],
  secret_key_base: web[:secret_key_base]
