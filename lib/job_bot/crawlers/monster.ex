defmodule JobBot.Crawler.Monster do
  use JobBot.Crawler

  import JobBot.Crawler.Helper

  alias HTTPoison.{Error, Response}
  alias JobBot.JobSearches.Listing
  alias JobBot.Source

  @base_url "https://www.monster.com"
  @source_name "Monster"

  def get_job_urls(job_search) do
    %{terms: terms, location: location} = job_search
    http_opts = [params: %{q: terms, where: location}]

    @base_url <> "/jobs/search/"
    |> HTTPoison.get([], http_opts)
    |> find_final_request_response()
    |> extract_urls_from_index()
  end

  def crawl_url_for_listing(url) do
    response =
      url
      |> HTTPoison.get()
      |> find_final_request_response()
    case response do
      {:ok, %Response{status_code: 200, body: body}} ->
        listing = 
          body
          |> Floki.parse()
          |> extract_listing_data_from_parsed_body()
          |> Map.put(:listing_url, url)
          |> ensure_application_url_present(url)

        {:ok, listing}        
      {:error, %Error{reason: reason}} ->
        message =
          "Error occured when trying to crawl url #{url}; REASON: #{reason}"
        {:error, message}
      _ ->
        {:error, "Failed to crawl listing at #{url}"}        
    end
  end

  defp extract_urls_from_index({:ok, %Response{status_code: 200, body: body}}) do
    body
    |> Floki.parse()
    |> Floki.attribute(".card-header .title a", "href")
    |> Enum.map(&relative_to_absolute_url(@base_url, &1))
  end
  defp extract_urls_from_index(_), do: []

  defp extract_listing_data_from_parsed_body(parsed) do
    %Listing{
      application_url: extract_application_url(parsed),
      city: extract_city(parsed),
      company_name: extract_company_name(parsed),
      description: extract_description(parsed),
      title: extract_title(parsed),
      source: @source_name
    }    
  end

  defp extract_application_url(parsed) do
    parsed
    |> Floki.attribute("a#PrimaryJobApply", "href")
    |> Enum.at(0)
  end

  defp extract_city(parsed) do
    parsed
    |> Floki.find("h2.subtitle")
    |> Floki.text()
  end

  defp extract_company_name(parsed) do
    parsed
    |> Floki.find("h1.title")
    |> Floki.text()
    |> String.split(~r/\s(at|from)\s/)
    |> Enum.at(1)
  end

  defp extract_description(parsed) do
    parsed
    |> Floki.find("#JobBody")
    |> Floki.raw_html()
  end

  defp extract_title(parsed) do
    parsed
    |> Floki.find("h1.title")
    |> Floki.text()
    |> String.split(~r/\s(at|from)\s/)
    |> Enum.at(0)
  end

  defp ensure_application_url_present(%Listing{application_url: nil} = listing, listing_url) do
    %{ listing | application_url: listing_url }
  end
  defp ensure_application_url_present(listing, _), do: listing
end