defmodule Poscaster.SubscriptionControllerTest do
  use Poscaster.ConnCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Poscaster.Factory
  alias Poscaster.Subscription

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "POST /api/subscriptions", %{conn: conn} do
    user = insert(:user)
    url = "http://www.rssboard.org/files/sample-rss-2.xml"
    use_cassette "example_feed" do
      conn = conn
      |> login(user)
      |> post("/api/subscriptions", %{subscription: %{url: url}})
      assert json_response(conn, 200) == %{
        "subscription" => %{
          "url" => url,
          "title" => "Liftoff News",
          "description" => "Liftoff to Space Exploration."
        }}

      subscription = Subscription
      |> Repo.get_by(%{})
      |> Repo.preload(:feed)
      assert subscription != nil
      assert subscription.feed.url == url
    end
  end

  test "POST /api/subscriptions (does not parse)", %{conn: conn} do
    user = insert(:user)
    url = "http://www.rssboard.org/files/sample-rss-2.xml"
    use_cassette "bad_body_feed" do
      conn = conn
      |> login(user)
      |> post("/api/subscriptions", %{subscription: %{url: url}})
      assert Map.get(json_response(conn, 422), "error") == "cannot_parse"
      subscription = Subscription
      |> Repo.get_by(%{})
      |> Repo.preload(:feed)
      assert subscription == nil
    end
  end
end
