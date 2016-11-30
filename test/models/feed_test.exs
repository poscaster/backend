defmodule Poscaster.FeedTest do
  use Poscaster.ModelCase

  alias Poscaster.Feed

  @valid_attrs %{description: "some content", last_fetched_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content", url: "some content"}
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
