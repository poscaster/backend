defmodule Poscaster.UserController do
  use Poscaster.Web, :controller
  alias Poscaster.User


  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        # |> Podcaster.Auth.login(user)
        |> render("user.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("error.json", changeset: changeset)
    end
  end
end
