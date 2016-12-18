defmodule Poscaster.SubscriptionController do
  use Poscaster.Web, :controller
  alias Poscaster.Feed
  alias Poscaster.Repo
  alias Poscaster.Subscription

  plug Guardian.Plug.EnsureAuthenticated

  def create(conn, %{"subscription" => %{"url" => url}}) do
    user = Guardian.Plug.current_resource(conn)
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
        |> put_status(400)
        |> render("error.json", %{error: error})
    end
    # conn
    # |> render("subscription.json", subscription: subscription)
  end
end
