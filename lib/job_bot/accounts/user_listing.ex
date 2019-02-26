defmodule JobBot.Accounts.UserListing do
  use Ecto.Schema
  import Ecto.Changeset

  alias JobBot.Accounts.User
  alias JobBot.Listing

  @derive {Poison.Encoder, only: [:user, :listing, :searched_for_at]}
  schema "user_listings" do
    field :searched_for_at, :naive_datetime
    field :applied_to_at, :naive_datetime
    belongs_to :user, JobBot.Accounts.User
    belongs_to :listing, JobBot.Listing

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:searched_for_at, :user_id, :listing_id])
    |> cast_assoc(:user, with: &User.changeset/2)
    |> cast_assoc(:listing, with: &Listing.changeset/2)
  end
end