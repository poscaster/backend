defmodule Poscaster.FeedItemTest do
  use Poscaster.ModelCase

  alias Poscaster.FeedItem

  @valid_attrs %{url: "some content", item_xml: "<test />"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FeedItem.changeset(%FeedItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FeedItem.changeset(%FeedItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
