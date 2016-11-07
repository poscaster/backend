use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Poscaster",
  ttl: { 90, :days },
  verify_issuer: true,
  secret_key: "",
  serializer: Poscaster.GuardianSerializer

import_config "test.secret.exs"
