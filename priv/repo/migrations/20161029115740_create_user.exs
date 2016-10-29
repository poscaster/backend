defmodule Poscaster.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :email, :string
      add :password_hash, :string

      timestamps(default: fragment("now()"))
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:login])
  end
end
