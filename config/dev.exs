use Mix.Config

config :poscaster, PoscasterWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :poscaster, PoscasterWeb.Guardian,
  allowed_algos: ["HS512"],
  issuer: "Poscaster",
  ttl: {90, :days},
  verify_issuer: true,
  secret_key: "secret"

import_config "dev.secret.exs"
