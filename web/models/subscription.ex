defmodule Poscaster.Subscription do
  use Poscaster.Web, :model

  schema "subscriptions" do
    field :active, :boolean, default: true
    belongs_to :feed, Poscaster.Feed
    belongs_to :user, Poscaster.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:active])
    |> cast_assoc(:feed)
    |> cast_assoc(:user)
    # |> validate_required(:feed_id, :user_id)
  end
end
