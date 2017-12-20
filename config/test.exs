use Mix.Config

config :poscaster, PoscasterWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :poscaster, PoscasterWeb.Guardian,
  allowed_algos: ["HS512"],
  issuer: "Poscaster",
  ttl: {90, :days},
  verify_issuer: true,
  secret_key: "dlb0xBErknui0vaf3W9d9n/m+I6+0ytcTFL+eIC8JeYojRzPSUrKXGPPQWH9f1GF"

import_config "test.secret.exs"
