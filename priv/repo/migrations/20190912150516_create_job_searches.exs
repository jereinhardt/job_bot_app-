defmodule JobBot.Repo.Migrations.CreateJobSearches do
  use Ecto.Migration

  def change do
    create table(:job_searches) do
      add :location, :string
      add :sources, {:array, :string}
      add :terms, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:job_searches, [:user_id])
  end
end
