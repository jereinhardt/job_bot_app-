defmodule JobBot.ListingProcessor do
  alias JobBot.{Accounts, Listing, Repo, UserRegistry}
  alias JobBot.Accounts.UserListing

  def process(listing, user_id) do
    with {:ok, listing} <- Listing.find_or_create(listing),
      {:ok, user_listing} <- create_user_listing(listing, user_id)
    do
      JobBotWeb.Endpoint.broadcast(
        "users:#{user_id}",
        "new_listing",
        %{"listing" => user_listing}
      )      
    end
  end

  defp create_user_listing(listing, user_id) do
    search_for_at = UserRegistry.get_user_data(user_id, :searched_for_at)
    Accounts.create_user_listing(%{
      searched_for_at: search_for_at,
      user_id: user_id,
      listing_id: listing.id
    })
  end
end