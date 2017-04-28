defmodule UserControllerTest do
  use Poscaster.ConnCase
  import Poscaster.Factory
  alias Poscaster.User

  test "POST /api/users", %{conn: conn} do
    password = "testtest"
    invitation = insert(:invitation)

    params = %{
      login: "test",
      email: "test@example.com",
      password: password,
      password_confirmation: password,
      invitation_code: invitation.code
    }
    conn = post conn, "/api/users", %{user: params}
    user = User
    |> Repo.get_by(%{invitation_code: invitation.code})

    assert user != nil
    assert json_response(conn, 200) == %{
      "user" => %{
        "login" => "test",
        "email" => "test@example.com"
    }}
    assert Comeonin.Bcrypt.checkpw(password, user.password_hash)
  end

  test "POST /api/users (w/o invitation)", %{conn: conn} do
    params = %{
      login: "test",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
    }
    conn = post conn, "/api/users", %{user: params}
    user = User
    |> Repo.get_by(%{login: "test"})

    assert user == nil
    assert json_response(conn, 422)
    |> get_in(["errors", "user", "invitation_code"]) == [ "can't be blank" ]
  end
end
