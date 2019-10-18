defmodule JobBot.ListingProcessor do
  alias JobBot.Accounts
  alias JobBot.JobSearches
  alias JobBot.JobSearches.JobSearch

  def process(listing, job_search_id) do
    listing_attrs = Map.from_struct(listing)
    job_search = JobSearches.get!(job_search_id)

    case JobSearches.create_listing(job_search, listing_attrs) do
      {:ok, listing} -> nil # TODO: see if it is possible to push this to a liveview socket
    end

    # with {:ok, listing} <- Listing.find_or_create(listing),
    #   {:ok, user_listing} <- create_user_listing(listing, user_id)
    # do
    #   JobBotWeb.Endpoint.broadcast(
    #     "users:#{user_id}",
    #     "new_listing",
    #     %{"listing" => user_listing}
    #   )      
    # end
  end
end