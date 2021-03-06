defmodule JobBot.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password, :binary

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
