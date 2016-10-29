defmodule Poscaster.Router do
  use Poscaster.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Poscaster do
    pipe_through :api
    pipe_through :api_auth

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: ~w(create delete)a
  end
end
