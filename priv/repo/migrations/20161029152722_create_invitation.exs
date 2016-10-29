defmodule Poscaster.Repo.Migrations.CreateInvitation do
  use Ecto.Migration

  def change do
    if direction == :up do
      execute "create extension if not exists \"uuid-ossp\""
    end

    create table(:invitations, primary_key: false) do
      add :code, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")

      timestamps(default: fragment("now()"))
    end

    alter table(:users) do
      add :invitation_code, references(:invitations, column: :code, type: :binary_id)
    end

    create unique_index(:users, [:invitation_code])
  end
end
