defmodule Poscaster.HttpFeedTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Poscaster.HttpFeed

  doctest HttpFeed

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test ".from_url fetches url and parses a valid feed" do
    use_cassette "example_feed" do
      {:ok, feed} = HttpFeed.from_url("http://www.rssboard.org/files/sample-rss-2.xml")
      assert %FeederEx.Feed{
        author: nil,
        id: nil,
        image: nil,
        language: "en-us",
        link: "http://liftoff.msfc.nasa.gov/",
        subtitle: nil,
        summary: "Liftoff to Space Exploration.",
        title: "Liftoff News",
        updated: "Tue, 10 Jun 2003 04:00:00 GMT",
        entries: [
          %FeederEx.Entry{author: nil,
                          duration: nil,
                          enclosure: nil,
                          id: "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573",
                          image: nil,
                          link: "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp",
                          subtitle: nil,
                          summary: "How do Americans get ready to work with Russians aboard the International Space Station? They take a crash course in culture, language and protocol at Russia's <a href=\"http://howe.iki.rssi.ru/GCTC/gctc_e.htm\">Star City</a>.",
                          title: "Star City",
                          updated: "Tue, 03 Jun 2003 09:39:21 GMT"
                         }
        ]
      } = feed;
    end
  end

  test ".from_url returns error on invalid response" do
    use_cassette "bad_body_feed" do
      assert {:error, :cannot_parse} = HttpFeed.from_url("http://www.rssboard.org/files/sample-rss-2.xml")
    end
  end

  test ".from_url returns error when cannot fetch" do
    use_cassette "bad_response_code_feed" do
      assert {:error, :cannot_fetch} = HttpFeed.from_url("http://www.rssboard.org/files/sample-rss-2.xml")
    end
  end

  test ".extract_feed_items returns sorted feed items" do
    res = Poscaster.HttpFeed.extract_feed_items %FeederEx.Feed{entries: [
      %FeederEx.Entry{updated: "Tue, 06 Dec 2016 22:05:23 GMT", enclosure: %{url: "http://example.com/e2"}},
      %FeederEx.Entry{updated: "Tue, 06 Dec 2016 23:05:25 +0100", enclosure: %{url: "http://example.com/e4"}},
      %FeederEx.Entry{updated: "Tue, 06 Dec 2016 19:05:24 -0300", enclosure: %{url: "http://example.com/e3"}},
      %FeederEx.Entry{updated: nil, enclosure: %{url: "http://example.com/e1"}}
    ]}
    assert Enum.map(res, &(Map.delete(&1, :pub_date))) == [
      %{url: "http://example.com/e4",
        item_data: %FeederEx.Entry{updated: "Tue, 06 Dec 2016 23:05:25 +0100", enclosure: %{url: "http://example.com/e4"}}},
      %{url: "http://example.com/e3",
        item_data: %FeederEx.Entry{updated: "Tue, 06 Dec 2016 19:05:24 -0300", enclosure: %{url: "http://example.com/e3"}}},
      %{url: "http://example.com/e2",
        item_data: %FeederEx.Entry{updated: "Tue, 06 Dec 2016 22:05:23 GMT", enclosure: %{url: "http://example.com/e2"}}},
      %{url: "http://example.com/e1",
        item_data: %FeederEx.Entry{enclosure: %{url: "http://example.com/e1"}}}
    ]
    res
    |> Enum.zip([
      Timex.to_datetime({{2016, 12, 6}, {23, 5, 25}}, "GMT-1"),
      Timex.to_datetime({{2016, 12, 6}, {19, 5, 24}}, "GMT+3"),
      Timex.to_datetime({{2016, 12, 6}, {22, 5, 23}}, "GMT"),
      nil])
    |> Enum.each(fn {a, b} ->
      assert Timex.equal?(a.pub_date, b)
    end)
  end
end
