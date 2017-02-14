defmodule Poscaster.FeedItem do
  @moduledoc """
  Fiid item model module
  """

  use Poscaster.Web, :model

  schema "feed_items" do
    field :url, :string
    field :item_xml, :string
    belongs_to :feed, Poscaster.Feed
    embeds_one :item_data, Podcaster.FeedItemData

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(%Poscaster.FeedItem{}, %{optional(any) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :item_xml])
    |> validate_required([:url, :item_xml])
  end
end
