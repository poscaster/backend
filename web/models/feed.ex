defmodule Poscaster.Feed do
  @moduledoc """
  Feed model module
  """

  use Poscaster.Web, :model
  import Ecto.Query
  alias Poscaster.HttpFeed
  alias Poscaster.Feed
  alias Poscaster.Repo

  schema "feeds" do
    field :url, :string
    field :title, :string
    field :description, :string
    field :last_fetched_at, Ecto.DateTime
    belongs_to :creator, Poscaster.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(%Feed{}, %{optional(any) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :description, :last_fetched_at])
    |> cast_assoc(:creator)
    |> validate_required([:url, :title, :description]) # , [:creator_id])
  end

  @spec get_by_url_or_create(String.t, %Poscaster.User{}|nil) :: {:ok, %Feed{}} | {:error, atom}
  def get_by_url_or_create(url, user \\ nil) do
    feed = find_by_url(url)

    if feed do
      {:ok, feed}
    else
      case HttpFeed.from_url(url) do
        {:ok, http_feed} ->
          feed_params = http_feed
          |> HttpFeed.extract_feed()
          |> Map.merge(%{url: url})
          changeset = %Feed{}
          |> changeset(feed_params)
          |> put_assoc(:creator, user)
          case Repo.insert(changeset, conflict_target: :url, on_conflict: :nothing) do
            {:ok, feed} ->
              if feed.id do
                {:ok, feed}
              else
                {:ok, find_by_url(url)}
              end
            {:error, _changeset} ->
              {:error, :cannot_save_feed}
          end
        {:error, err} ->
          {:error, err}
      end
    end
  end

  @spec find_by_url(String.t) :: %Feed{} | nil
  defp find_by_url(url) do
    Feed
    |> where([f], f.url == ^url)
    |> first
    |> Repo.one
  end
end
