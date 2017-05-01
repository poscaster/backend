defmodule Poscaster.Repo.Migrations.CreateFeed do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :url, :string, null: false
      add :title, :string
      add :description, :text
      add :last_fetched_at, :timestamp
      add :creator_id, references(:users, on_delete: :nothing)

      timestamps(default: fragment("now()"))
    end

    create unique_index(:feeds, [:url])
  end
end
