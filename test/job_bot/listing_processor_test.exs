defmodule JobBot.ListingProcessorTest do
  use ExUnit.Case
  use JobBotWeb.FactoryCase

  import Ecto.Query, warn: false
  import Mock

  alias JobBot.{Listing, ListingProcessor, Repo, UserRegistry}
  alias JobBot.Accounts.UserListing
  alias JobBotWeb.Endpoint

  describe "process/2" do
    test "creates a user listing and broadcasts the listing" do
      with_mock(Endpoint, [broadcast: fn(_, _, _) -> nil end]) do
        user = insert(:user)
        listing = insert(:listing)
        UserRegistry.register(user.id, [searched_for_at: DateTime.utc_now()])

        ListingProcessor.process(listing, user.id)

        assert called Endpoint.broadcast(
          "users:#{user.id}",
          "new_listing",
          %{"listing" => listing}
        )
      end
    end
  end
end