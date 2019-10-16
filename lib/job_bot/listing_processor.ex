defmodule JobBot.ListingProcessor do
  alias JobBot.{Accounts, Repo, UserRegistry}
  alias JobBot.JobSearches.Listing

  def process(%Listing{id: id} = listing, user_id) when is_integer(id) do
    with {:ok, user_listing} <- create_user_listing(listing, user_id) do
      JobBotWeb.Endpoint.broadcast(
        "users:#{user_id}",
        "new_listing",
        %{"listing" => user_listing}
      )
    end      
  end

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
    attrs = %{
      searched_for_at: search_for_at,
      user_id: user_id,
      listing_id: listing.id
    }
    case Accounts.create_user_listing(attrs) do
      {:ok, user_listing} ->
        user_listing_with_data = Repo.preload(user_listing, :listing)
        {:ok, user_listing_with_data}
      {:error, message} ->
        {:error, message}
    end
  end
end