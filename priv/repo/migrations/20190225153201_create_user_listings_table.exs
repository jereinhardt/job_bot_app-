defmodule JobBot.Repo.Migrations.CreateUserListingsTable do
  use Ecto.Migration

  def change do
    create table(:user_listings) do
      add :user_id, references(:users)
      add :listing_id, references(:listings)
      add :searched_for_at, :naive_datetime, null: false
      add :applied_to_at, :naive_datetime

      timestamps()
    end
  end
end
