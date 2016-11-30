defmodule Poscaster.SubscriptionItemTest do
  use Poscaster.ModelCase

  alias Poscaster.SubscriptionItem

  @valid_attrs %{finished: true, paused_at: 0}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SubscriptionItem.changeset(%SubscriptionItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SubscriptionItem.changeset(%SubscriptionItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
