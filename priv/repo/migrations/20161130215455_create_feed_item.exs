defmodule Poscaster.Repo.Migrations.CreateFeedItem do
  use Ecto.Migration

  def change do
    create table(:feed_items) do
      add :url, :string, null: false
      add :item_data, :map
      add :item_xml, :string
      add :pub_date, :timestamp
      add :feed_id, references(:feeds, on_delete: :nothing)

      timestamps(default: fragment("now()"))
    end

    create index(:feed_items, [:feed_id, "(\"item_data\" ->> 'id')"])
  end
end
