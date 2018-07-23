defmodule JobBot.CrawlerCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      defp listing_matches_response?(listing, response) do
        {message, response_listing} = response
        message == :ok &&
          listing.title == response_listing.title &&
          listing.company_name == response_listing.company_name &&
          listing.email == response_listing.email &&
          listing.application_url == response_listing.application_url
      end
    end
  end
end