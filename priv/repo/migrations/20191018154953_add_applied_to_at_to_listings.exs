defmodule JobBot.Repo.Migrations.AddAppliedToAtToListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :applied_to_at, :naive_datetime
    end
  end
end
