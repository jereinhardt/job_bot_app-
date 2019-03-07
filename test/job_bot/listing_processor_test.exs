defmodule JobBot.ListingProcessorTest do
  use ExUnit.Case
  use JobBotWeb.FactoryCase

  import Ecto.Query, warn: false
  import Mock

  alias JobBot.{ListingProcessor, Repo, UserRegistry}
  alias JobBot.Accounts.UserListing
  alias JobBotWeb.Endpoint

  describe "process/2" do
    test "creates a user listing and broadcasts the listing" do
      with_mock(Endpoint, [broadcast: fn(_, _, _) -> nil end]) do
        user = insert(:user)
        listing = insert(:listing)
        UserRegistry.register(user.id, [searched_for_at: DateTime.utc_now()])

        ListingProcessor.process(listing, user.id)
        query = from ul in UserListing,
          order_by: [desc: ul.inserted_at],
          preload: [:listing],
          limit: 1
        user_listing = Repo.one(query)

        assert called Endpoint.broadcast(
          "users:#{user.id}",
          "new_listing",
          %{"listing" => user_listing}
        )
      end
    end
  end
end