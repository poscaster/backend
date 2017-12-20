defmodule Poscaster.HttpFeed do
  @moduledoc """
  HTTP feed model module
  """

  @doc ~S"""
  Fetches and parses feed by url
  """
  @spec from_url(String.t) :: {:ok, %FeederEx.Feed{}} | {:error, atom}
  def from_url(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: code}} when code < 400 and code >= 200 ->
        case FeederEx.parse(body) do
          {:ok, feed, _} ->
            {:ok, feed}
          _ ->
            {:error, :cannot_parse}
        end
      _ ->
        {:error, :cannot_fetch}
    end
  end

  @doc ~S"""
  Extracts feed attributes from FeederEx'es Feed.

  ## Examples

    iex(1)> Poscaster.HttpFeed.extract_feed %FeederEx.Feed{
    ...(1)>   summary: "Awesone podcast feed description",
    ...(1)>   title: "Awesomecast"}
    %{title: "Awesomecast", description: "Awesone podcast feed description"}
  """
  @spec extract_feed(%FeederEx.Feed{}) :: %{title: String.t, description: String.t}
  def extract_feed(%FeederEx.Feed{summary: description, title: title}) do
    %{
      title: title,
      description: description
    }
  end

  @doc ~S"""
  Extracts feed items attributes from FeederEx'es Feed.
  """
  @spec extract_feed_items(%FeederEx.Feed{}) :: [%{
                                                    url: String.t,
                                                    item_data: %{optional(any) => any},
                                                    pub_date: %DateTime{} | nil
                                                 }]
  def extract_feed_items(%FeederEx.Feed{entries: entries}) do
    entries
    |> Enum.map(fn(%FeederEx.Entry{enclosure: %{url: url}, updated: pub_date} = item_data) ->
      %{
        url: url,
        item_data: item_data,
        pub_date: case Timex.parse(pub_date, "{RFC1123}") do
                    {:ok, date_time} -> date_time
                    _ -> nil
                  end
      }
    end)
    |> Enum.filter(fn %{url: url} -> url end)
    |> Enum.sort_by(fn %{pub_date: pub_date} ->
      if pub_date, do: -Timex.to_unix(pub_date), else: 0
    end)
  end
end
