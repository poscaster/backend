defmodule Poscaster.Repo.Migrations.CreateImpression do
  use Ecto.Migration

  def change do
    create table(:impressions) do
      add :paused_at, :integer
      add :finished, :boolean, default: false, null: false
      add :rating, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :feed_item_id, references(:feed_items, on_delete: :nothing)

      timestamps(default: fragment("now()"))
    end

    create unique_index(:impressions, [:user_id, :feed_item_id])
    create constraint(:impressions, :rating_value, check: "rating > 0 and rating <= 5 or rating is null")
  end
end
