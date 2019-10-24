defmodule JobBot.ListingProcessorTest do
  use ExUnit.Case
  use JobBotWeb.FactoryCase

  import Ecto.Query, warn: false
  import JobBot.Factory
  import Mock

  alias JobBot.JobSearches.Listing
  alias JobBot.JobSearches.LiveUpdates
  alias JobBot.ListingProcessor
  alias JobBot.Repo

  describe "process/2" do
    test "creates a user listing and broadcasts the listing" do
      with_mock(LiveUpdates, [broadcast_new_listing: fn(_, _) -> nil end]) do
        job_search = insert(:job_search) |> Repo.preload([:listings])
        listing = build(:listing)

        ListingProcessor.process(listing, job_search.id)
        listing = Repo.all(Listing) |> List.last()

        assert called LiveUpdates.broadcast_new_listing(job_search, listing)
      end
    end
  end
end