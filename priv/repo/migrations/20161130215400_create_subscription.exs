defmodule Poscaster.Repo.Migrations.CreateSubscription do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :feed_id, references(:feeds, on_delete: :nothing)
      add :active, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(default: fragment("now()"))
    end

    create unique_index(:subscriptions, [:user_id, :feed_id])
  end
end
