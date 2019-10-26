defmodule JobBot.ListingProcessor do
  alias JobBot.Accounts
  alias JobBot.JobSearches
  alias JobBot.JobSearches.JobSearch
  alias JobBot.JobSearches.LiveUpdates

  def process(listing, job_search_id) do
    listing_attrs = Map.from_struct(listing)
    job_search = JobSearches.get!(job_search_id)

    with {:ok, listing} <- JobSearches.create_listing(job_search, listing_attrs) do
      LiveUpdates.broadcast_new_listing(job_search, listing)
    end
  end
end