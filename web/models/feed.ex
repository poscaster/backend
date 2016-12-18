defmodule Poscaster.Feed do
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
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :description, :last_fetched_at])
    |> cast_assoc(:creator)
    |> validate_required([:url, :title, :description]) # , [:creator_id])
  end

  def get_by_url_or_create(url, user \\ nil) do
    feed = Feed
    |> where([f], f.url == ^url)
    |> first
    |> Repo.one

    if feed do
      {:ok, feed}
    else
      case HttpFeed.from_url(url) do
        {:ok, http_feed} ->
          feed_params = HttpFeed.extract_feed(http_feed)
          |> Map.merge(%{url: url})
          changeset = changeset(%Feed{}, feed_params)
          |> put_assoc(:creator, user)
          case Repo.insert(changeset) do
            {:ok, feed} ->
              {:ok, feed}
            {:error, _changeset} ->
              {:error, :cannot_save_feed}
          end
        {:error, err} ->
          {:error, err}
      end
    end
  end
end
