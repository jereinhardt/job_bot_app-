defmodule JobBot.ListingTest do
  use ExUnit.Case
  use JobBotWeb.FactoryCase

  alias JobBot.Listing

  describe "find_or_create/1" do
    test "returns existing listing based on listing url and company name" do
      existing_listing = insert(:listing)
      arg = %Listing{
        listing_url: existing_listing.listing_url,
        company_name: existing_listing.company_name
      }

      listing = Listing.find_or_create(arg)

      assert listing == {:ok, existing_listing}
    end

    test "creates a listing if none exist" do
      existing_listing = insert(:listing)
      arg = %Listing{
        company_name: "Work Co.",
        description: "an awesome job",
        listing_url: "www.applyhere.com",
        title: "an awesome job"
      }

      {:ok, listing} = Listing.find_or_create(arg)

      assert listing.id != existing_listing.id
    end
  end
end