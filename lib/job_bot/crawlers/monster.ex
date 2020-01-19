defmodule JobBot.Crawler.Monster do
  use JobBot.Crawler,
    base_url: "https://www.monster.com",
    source_name: "Monster"

  alias HTTPoison.{Error, Response}
  alias JobBot.JobSearches.Listing
  alias JobBot.Source

  def crawl_job_search_index(job_search) do
    %{terms: terms, location: location} = job_search
    http_opts = [params: %{q: terms, where: location}]
    url = @base_url <> "/jobs/search"

    if crawlable?("#{url}?q=#{terms}") do
      url
      |> HTTPoison.get([], http_opts)
      |> find_final_request_response()
      |> find_search_index_listings()
      |> Enum.map(&parse_search_result_for_listing/1)
    else
      []
    end
  end

  def crawl_listing(listing) do
    with response <- HTTPoison.get(listing.listing_url),
      {:ok, %Response{status_code: 200, body: body}} <- find_final_request_response(response)
    do
      listing =
        body
        |> Floki.parse()
        |> parse_job_page_for_listing_attributes()
        |> update_listing(listing)

      {:ok, listing}
    else
      _ -> {:error, "Failed to crawl listing at #{listing.listing_url}"}  
    end 
  end

  defp find_search_index_listings({:ok, %Response{status_code: 200, body: body}}) do
    body
    |> Floki.parse()
    |> Floki.find("#SearchResults section.card-content:not(.apas-ad)")
  end
  defp find_search_index_listings(_), do: []

  defp parse_search_result_for_listing(parsed) do
    listing_url = extract_listign_url_from_index_result(parsed)

    %Listing{
      city: extract_city_from_index_result(parsed),
      company_name: extract_company_name_from_index_result(parsed),
      title: extract_title_from_index_result(parsed),
      listing_url: listing_url,
      application_url: listing_url,
      source: @source_name
    }
  end

  defp extract_city_from_index_result(parsed) do
    parsed
    |> Floki.find(".location")
    |> Floki.text()
    |> String.trim()
  end

  defp extract_company_name_from_index_result(parsed) do
    parsed
    |> Floki.find(".title")
    |> Floki.text()
    |> String.trim()
  end

  defp extract_title_from_index_result(parsed) do
    parsed
    |> Floki.find(".company")
    |> Floki.text()
    |> String.trim()
  end

  defp extract_listign_url_from_index_result(parsed) do
    parsed
    |> Floki.attribute("a", "href")
    |> List.first()
  end

  defp parse_job_page_for_listing_attributes(parsed) do
    %{
      application_url: extract_application_url(parsed),
      description: extract_description(parsed),
    }    
  end

  defp extract_application_url(parsed) do
    parsed
    |> Floki.attribute("a#PrimaryJobApply", "href")
    |> Enum.at(0)
  end

  defp extract_description(parsed) do
    parsed
    |> Floki.find("#JobBody")
    |> Floki.raw_html()
  end

  defp update_listing(%{application_url: nil} = attrs, listing) do
    attrs
    |> Map.delete(:application_url)
    |> update_listing(listing)
  end

  defp update_listing(attrs, listing) do
    Map.merge(listing, attrs)
  end
end