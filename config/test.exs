use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

import_config "test.secret.exs"
