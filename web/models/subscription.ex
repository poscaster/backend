defmodule Poscaster.Subscription do
  @moduledoc """
  Subscription model module
  """

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
  @spec changeset(%Poscaster.Subscription{}, %{optional(any) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> Repo.preload(:feed)
    |> Repo.preload(:user)
    |> cast(params, [:active])
  end

  @spec creation_changeset(%Poscaster.Subscription{}, %Poscaster.Feed{}, %Poscaster.User{},
    %{optional(any) => any}) :: %Ecto.Changeset{}
  def creation_changeset(struct, feed, user, params \\ %{}) do
    struct
    |> changeset(params)
    |> put_assoc(:feed, feed)
    |> put_assoc(:user, user)
    |> validate_required([:feed, :user])
    |> unique_constraint(:feed, name: :subscriptions_user_id_feed_id_index)
  end
end
