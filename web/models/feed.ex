defmodule Poscaster.Feed do
  use Poscaster.Web, :model

  schema "feeds" do
    field :url, :string
    field :title, :string
    field :description, :string
    field :last_fetched_at, Ecto.DateTime
    belongs_to :creator, Poscaster.Creator

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :description, :last_fetched_at])
    |> validate_required([:url, :title, :description, :last_fetched_at])
  end
end
