defmodule Poscaster.SubscriptionTest do
  use Poscaster.ModelCase
  import Poscaster.Factory
  alias Poscaster.Subscription

  @valid_attrs %{active: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Subscription.creation_changeset(%Subscription{}, build(:feed), build(:user), @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Subscription.creation_changeset(%Subscription{}, nil, nil, @invalid_attrs)
    refute changeset.valid?
  end
end
