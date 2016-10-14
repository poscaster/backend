defmodule Poscaster.Endpoint do
  use Phoenix.Endpoint, otp_app: :poscaster

  socket "/socket", Poscaster.UserSocket

  plug Plug.Static,
    at: "/", from: :poscaster, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_poscaster_key",
    signing_salt: "rthwvLJD"

  plug Poscaster.Router
end
