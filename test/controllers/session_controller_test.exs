defmodule PoscasterWeb.SessionControllerTest do
  use PoscasterWeb.ConnCase
  import Poscaster.Factory

  test "POST /api/sessions", %{conn: conn} do
    user = insert(:user)

    params = %{login: user.login, password: user.password}
    conn = post conn, "/api/sessions", %{user: params}

    response = json_response(conn, 200)
    assert Map.get(response, "user") == %{
      "login" => user.login,
      "email" => user.email
    }
    assert List.first(get_resp_header(conn, "authorization")) =~ ~r{\ABearer }
    assert List.first(get_resp_header(conn, "x-expires")) =~ ~r{\A\d+\z}
  end

  test "POST /api/sessions (when user does not exist)", %{conn: conn} do
    params = %{login: "test", password: "password"}
    conn = post conn, "/api/sessions", %{user: params}

    response = json_response(conn, 401)
    assert Map.get(response, "error") == "Could not login"
    assert List.first(get_resp_header(conn, "authorization")) == nil
  end

  test "GET /api/sessions", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> login(user)
    |> get("/api/sessions")

    response = json_response(conn, 200)

    assert Map.get(response, "user") == %{
      "login" => user.login,
      "email" => user.email
    }
    assert List.first(get_resp_header(conn, "authorization")) =~ ~r{\ABearer }
    assert List.first(get_resp_header(conn, "x-expires")) =~ ~r{\A\d+\z}
  end

  test "DELETE /api/sessions", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> login(user)
    |> delete("/api/sessions/1", %{})

    assert json_response(conn, 200) == %{
      "user" => nil,
      "jwt" => nil,
      "exp" => nil
    }
    assert PoscasterWeb.Guardian.Plug.current_resource(recycle(conn)) == nil
  end
end
