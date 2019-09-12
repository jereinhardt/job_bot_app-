defmodule JobBot.Repo.Migrations.EraseUnusedUserListingData do
  use Ecto.Migration
  alias JobBot.{Repo, Listing}
  alias JobBot.Accounts.UserListing

  def change do
    Repo.delete_all UserListing

    drop table("user_listings")

    Repo.delete_all Listing

    alter table("listings") do
      add :job_search_id, :integer, null: false
    end
  end
end
