defmodule PoscasterWeb.Router do
  use Poscaster.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline, module: PoscasterWeb.Guardian,
                                 error_handler: PoscasterWeb.Guardian.AuthErrorHandler
    # plug PoscasterWeb.Guardian.AuthPipeline
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, realm: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  scope "/api", PoscasterWeb do
    pipe_through :api
    pipe_through :api_auth

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: ~w(create index delete)a
    resources "/feeds", FeedController do
      post "/refetch", FeedController, :refetch, as: :refetch
      resources "/feed_items", FeedItemController, only: ~w(index)a
    end
    resources "/subscriptions", SubscriptionController, only: ~w(create index)a
  end
end
