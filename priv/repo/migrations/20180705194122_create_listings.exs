defmodule JobBot.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :title, :string
      add :description, :text
      add :city, :string
      add :remote, :boolean, default: false, null: false
      add :salary, :string
      add :email, :string
      add :company_name, :string
      add :listing_url, :text
      add :application_url, :text
      add :skills, {:array, :string}
      add :source, :string

      timestamps()
    end

  end
end
