use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Poscaster",
  ttl: { 90, :days },
  verify_issuer: true,
  secret_key: "",
  serializer: Poscaster.GuardianSerializer

import_config "dev.secret.exs"
