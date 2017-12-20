defmodule PoscasterWeb.SubscriptionController do
  use Poscaster.Web, :controller
  alias PoscasterWeb.Guardian.Plug, as: GPlug
  alias Poscaster.Feed
  alias Poscaster.Repo
  alias Poscaster.Subscription

  plug Guardian.Plug.EnsureAuthenticated
  plug :scrub_params, "url" when action == :create

  @spec index(Plug.Conn.t, %{}) :: Plug.Conn.t
  def index(conn, %{}) do
    subscriptions = conn
    |> GPlug.current_resource()
    |> Subscription.get_active_for_user()
    render(conn, "subscriptions.json", %{subscriptions: subscriptions})
  end

  @spec create(Plug.Conn.t, %{optional(String.t) => any}) :: Plug.Conn.t
  def create(conn, %{"url" => url}) do
    user = GPlug.current_resource(conn)
    case Feed.get_by_url_or_create(url, user) do
      {:ok, feed} ->
        changeset = %Subscription{}
        |> Subscription.creation_changeset(feed, user)
        case Repo.insert(changeset) do
          {:ok, subscription} ->
            render(conn, "subscription.json", %{subscription: subscription})
          {:error, _changeset} ->
            conn
            |> put_status(422)
            |> render("error.json", %{error: :cannot_save_subscription})
        end
      {:error, error} ->
        conn
        |> put_status(422)
        |> render("error.json", %{error: error})
    end
  end
end
