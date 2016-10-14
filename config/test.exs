use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :poscaster, Poscaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "poscaster_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
