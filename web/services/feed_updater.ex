defmodule Poscaster.FeedUpdater do
  import Ecto.Query
  alias Poscaster.FeedItem
  alias Poscaster.HttpFeed
  alias Poscaster.Repo

  @moduledoc """
  Feed updater service.

  Fetches feed data and updates feed with associated feed items.
  """

  @spec refetch(%Poscaster.Feed{}) :: nil
  def refetch(feed) do
    case HttpFeed.from_url(feed.url) do
      {:ok, http_feed} ->
        http_feed
        |> HttpFeed.extract_feed_items()
        |> update_feed_items(feed)
    end

    nil
  end

  @spec update_feed_items([], %Poscaster.Feed{}) :: nil
  defp update_feed_items([], _), do: nil

  defp update_feed_items(http_feed_items, feed) do
    min_date = http_feed_items
    |> Enum.map(fn %{pub_date: date} -> DateTime.to_unix(date) end)
    |> Enum.min

    existing_feed_items_map = FeedItem
    |> where([fi], fi.pub_date >= fragment("to_timestamp(?) at time zone 'UTC'", ^min_date))
    |> Repo.all()
    |> Enum.reduce(%{}, fn fi, acc ->
      Map.put(acc, {DateTime.to_unix(fi.pub_date), fi.item_data["id"]}, fi)
    end)

    http_feed_items
    |> Enum.map(fn %{pub_date: pub_date, item_data: %{id: id} = item_data} = item ->
      item_data = item_data
      |> Map.put(:enclosure, Map.from_struct(Map.get(item_data, :enclosure, nil)))
      item = item
      |> Map.put(:item_data, Map.from_struct(item_data))
      case existing_feed_items_map[{DateTime.to_unix(pub_date), id}] do
        %Poscaster.FeedItem{} = ex_item ->
          ex_item
          |> Repo.preload(:feed)
          |> FeedItem.changeset(item)
        nil ->
          %Poscaster.FeedItem{feed: feed}
          |> FeedItem.changeset(item)
      end
    end)
    |> Enum.each(&Repo.insert_or_update/1)

    nil
  end
end
