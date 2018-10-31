use Mix.Config

config :logger, level: :warn

config :auth, Auth.Repo,
  database: "auth_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Reduce number of rounds of encryption so tests are fast
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
