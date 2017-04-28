defmodule Poscaster.SessionController do
  use Poscaster.Web, :controller

  alias Poscaster.User
  alias Guardian.Plug, as: GPlug
  alias Plug.Conn

  plug :scrub_params, "user" when action in [:create]

  @spec create(Conn.t, %{optional(String.t) => any}) :: Conn.t
  def create(conn, params) do
    case User.find_and_confirm_password(params) do
      {:ok, user} ->
        new_conn = GPlug.api_sign_in(conn, user)
        jwt = GPlug.current_token(new_conn)
        {:ok, claims} = GPlug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> Conn.put_resp_header(<<"authorization">>, <<"Bearer #{jwt}">>)
        |> Conn.put_resp_header(<<"x-expires">>, :erlang.integer_to_binary(exp))
        |> render("session.json", user: user, jwt: jwt, exp: exp)
      {:error} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end

  @spec delete(Conn.t, %{optional(String.t) => any}) :: Conn.t
  def delete(conn, _params) do
    jwt = GPlug.current_token(conn)
    {:ok, claims} = GPlug.claims(conn)
    Guardian.revoke!(jwt, claims)
    conn
    |> render("session.json", user: nil, jwt: nil, exp: nil)
  end
end
