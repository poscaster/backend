defmodule PoscasterWeb.FeedItemController do
  use Poscaster.Web, :controller
  alias Poscaster.Feed
  alias Poscaster.Repo

  def index(conn, %{"feed_id" => id}) do
    case Repo.get(Feed, id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{success: false})
      feed ->
        page_size = extract_page_size(conn)
        offset = extract_offset(conn)
        items = FeedItem
        |> where([fi], fi.feed_id == ^feed.id)
        |> order_by([:pub_date, :id])
        |> limit(^page_size)
        |> offset(^offset)
        |> Repo.all

        render(conn, "feed_items.json", %{feed_items: items})
    end
  end
end
