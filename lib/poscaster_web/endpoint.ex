defmodule PoscasterWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :poscaster

  socket "/socket", PoscasterWeb.UserSocket

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  @spec redirect_index(Plug.Conn.t, any) :: Plug.Conn.t
  def redirect_index(conn = %Plug.Conn{path_info: []}, _opts) do
    %Plug.Conn{conn | path_info: ["index.html"]}
  end

  @spec redirect_index(Plug.Conn.t, any) :: Plug.Conn.t
  def redirect_index(conn, _opts) do
    conn
  end

  plug :redirect_index

  plug Plug.Static,
    at: "/", from: :poscaster, gzip: true

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

  # CORS for API
  plug CORSPlug

  plug PoscasterWeb.Router
end
