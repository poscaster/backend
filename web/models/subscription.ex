defmodule Poscaster.Subscription do
  use Poscaster.Web, :model
  alias Poscaster.Repo

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
    |> Repo.preload(:feed)
    |> Repo.preload(:user)
    |> cast(params, [:active])
  end

  def creation_changeset(struct, feed, user, params \\ %{}) do
    struct
    |> changeset(params)
    |> put_assoc(:feed, feed)
    |> put_assoc(:user, user)
    |> validate_required([:feed, :user])
  end
end
