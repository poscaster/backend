defmodule Poscaster.FeedTest do
  use Poscaster.ModelCase

  alias Poscaster.Feed

  @valid_attrs %{
    description: "some content",
    last_fetched_at: Timex.to_datetime({{2016, 4, 17}, {14, 0, 0}}, "GMT"),
    title: "some content",
    url: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Feed.changeset(%Feed{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Feed.changeset(%Feed{}, @invalid_attrs)
    refute changeset.valid?
  end
end
