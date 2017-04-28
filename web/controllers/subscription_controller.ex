defmodule Poscaster.SubscriptionController do
  use Poscaster.Web, :controller
  alias Guardian.Plug, as: GPlug
  alias Poscaster.Feed
  alias Poscaster.Repo
  alias Poscaster.Subscription

  plug Guardian.Plug.EnsureAuthenticated

  @spec create(Plug.Conn.t, %{optional(String.t) => any}) :: Plug.Conn.t
  def create(conn, %{"subscription" => %{"url" => url}}) do
    user = GPlug.current_resource(conn)
    case Feed.get_by_url_or_create(url, user) do
      {:ok, feed} ->
        changeset = %Subscription{}
        |> Subscription.creation_changeset(feed, user)
        case Repo.insert(changeset) do
          {:ok, subscription} ->
            conn
            |> render("subscription.json", %{subscription: subscription})
          {:error, _changeset} ->
            conn
            |> render("error.json", %{error: :cannot_save_subscription})
        end
      {:error, error} ->
        conn
        |> put_status(422)
        |> render("error.json", %{error: error})
    end
  end
end
