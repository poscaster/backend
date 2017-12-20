defmodule Poscaster.Impression do
  @moduledoc """
  Subscription item model module
  """

  use Poscaster.Web, :model

  schema "subscription_items" do
    field :paused_at, :integer
    field :finished, :boolean, default: false
    field :rating, :integer
    belongs_to :user, Poscaster.User
    belongs_to :feed_item, Poscaster.FeedItem

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(%Poscaster.Impression{}, %{optional(any) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:paused_at, :finished])
    |> validate_required([:paused_at, :finished])
  end
end
