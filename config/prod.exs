use Mix.Config

config :poscaster, Poscaster.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "poscaster.herokuapp.com", port: 443],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

config :poscaster, Poscaster.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  ssl: true,
  pool_size: 10

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Poscaster",
  ttl: { 90, :days },
  verify_issuer: true,
  secret_key: fn ->
    System.get_env("GUARDIAN_SECRET_KEY")
  end,
  serializer: Poscaster.GuardianSerializer
