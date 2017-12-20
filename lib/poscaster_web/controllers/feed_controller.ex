defmodule PoscasterWeb.FeedController do
  use Poscaster.Web, :controller
  alias Poscaster.Feed
  alias Poscaster.FeedUpdater
  alias Poscaster.Repo

  plug Guardian.Plug.EnsureAuthenticated

  @spec refetch(Plug.Conn.t, %{optional(String.t) => any}) :: Plug.Conn.t
  def refetch(conn, %{"feed_id" => id}) do
    case Repo.get(Feed, id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{success: false})
      feed ->
        Task.start_link fn ->
          FeedUpdater.refetch(feed)
        end
        conn
        |> json(%{success: true})
    end
  end
end
