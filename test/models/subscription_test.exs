defmodule Poscaster.SubscriptionTest do
  use Poscaster.ModelCase

  alias Poscaster.Subscription

  @valid_attrs %{active: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Subscription.changeset(%Subscription{}, @valid_attrs)
    assert changeset.valid?
  end

	@tag :skip
  test "changeset with invalid attributes" do
    changeset = Subscription.changeset(%Subscription{}, @invalid_attrs)
    refute changeset.valid?
  end
end
