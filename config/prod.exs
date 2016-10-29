use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "poscaster.herokuapp.com", port: 443],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

config :poscaster, Poscaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: 10
