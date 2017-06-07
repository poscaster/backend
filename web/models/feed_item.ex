defmodule Poscaster.FeedItem do
  @moduledoc """
  Feed item model module
  """

  use Poscaster.Web, :model

  schema "feed_items" do
    field :url, :string
    field :item_xml, :string
    field :pub_date, :utc_datetime
    field :item_data, :map
    belongs_to :feed, Poscaster.Feed

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(%Poscaster.FeedItem{}, %{optional(any) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :pub_date, :item_data])
    |> validate_required([:url, :feed])
  end
end
