defmodule Poscaster.SessionController do
  use Poscaster.Web, :controller

  alias Poscaster.User

  plug :scrub_params, "user" when action in [:create]

  def create(conn, params) do
    case User.find_and_confirm_password(params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> Plug.Conn.put_resp_header(<<"Authorization">>, <<"Bearer #{jwt}">>)
        |> Plug.Conn.put_resp_header(<<"X-Expires">>, :erlang.integer_to_binary(exp))
        |> render("session.json", user: user, jwt: jwt, exp: exp)
      {:error} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    conn
    |> render("session.json", user: nil, jwt: nil, exp: nil)
  end
end