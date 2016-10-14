use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :poscaster, Poscaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "poscaster_dev",
  hostname: "localhost",
  pool_size: 10
