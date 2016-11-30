defmodule Poscaster.SubscriptionItem do
  use Poscaster.Web, :model

  schema "subscription_items" do
    field :paused_at, :integer
    field :finished, :boolean, default: false
    belongs_to :subscription, Poscaster.Subscription
    belongs_to :feed_item, Poscaster.FeedItem

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:paused_at, :finished])
    |> validate_required([:paused_at, :finished])
  end
end
