defmodule JobBot.Accounts.UserListing do
  use Ecto.Schema
  import Ecto.Changeset

  alias JobBot.Accounts.User
  alias JobBot.Listing

  schema "user_listings" do
    field :searched_for_at, :naive_datetime
    field :applied_to_at, :naive_datetime
    belongs_to :user, User
    belongs_to :listing, Listing

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:applied_to_at, :searched_for_at, :user_id, :listing_id])
    |> cast_assoc(:user, with: &User.changeset/2)
    |> cast_assoc(:listing, with: &Listing.changeset/2)
  end
end

defimpl Poison.Encoder, for: JobBot.Accounts.UserListing do
  def encode(%{listing: %JobBot.Listing{}} = user_listing, options) do
    attrs = Map.take(user_listing, encoded_properties)
    user_listing
    |> Map.get(:listing)
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.merge(attrs)
    |> Poison.Encoder.Map.encode(options)
  end

  def encode(%{listing: listing} = user_listing, options) when is_map(listing) do
    attrs = Map.take(user_listing, encoded_properties)
    listing
    |> Map.merge(attrs)
    |> Poison.Encoder.Map.encode(options)
  end

  def encoded_properties, do: [:id, :listing_id, :searched_for_at, :applied_to_at]
end