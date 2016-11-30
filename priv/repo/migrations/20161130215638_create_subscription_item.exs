defmodule Poscaster.Repo.Migrations.CreateSubscriptionItem do
  use Ecto.Migration

  def change do
    create table(:subscription_items) do
      add :paused_at, :integer
      add :finished, :boolean, default: false, null: false
      add :subscription_id, references(:subscriptions, on_delete: :nothing)
      add :feed_item_id, references(:feed_items, on_delete: :nothing)

      timestamps(default: fragment("now()"))
    end

    create unique_index(:subscription_items, [:subscription_id, :feed_item_id])
		create index(:subscription_items, ~w(subscription_id finished inserted_at)a)
  end
end
