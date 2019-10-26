defmodule JobBot.Crawler.CareerBuilder do
  use JobBot.Crawler

  import JobBot.Crawler.Helper

  alias HTTPoison.{Error, Response}
  alias JobBot.JobSearches.Listing
  alias JobBot.Source
  
  @base_url "https://www.careerbuilder.com"
  @source_name "CareerBuilder"

  def get_job_urls(job_search) do
    %{terms: terms, location: location} = job_search
    http_opts = [params: %{ keywords: terms, location: location }]

    @base_url <> "/jobs"
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
    |> Floki.attribute("a.job-listing-item", "href")
    |> Enum.map(&relative_to_absolute_url(@base_url, &1))
  end
  defp extract_urls_from_index({_, _}), do: []

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
    href =
      parsed
      |> Floki.attribute(".data-display-header_info-apply a", "href")
      |> Enum.at(0)
    if String.starts_with?(href, "http") do
      href
    else
      relative_to_absolute_url(@base_url, href)
    end
  end

  defp extract_city(parsed) do
    parsed
    |> Floki.find(".data-display-header_info-content .data-details span")
    |> Enum.at(1)
    |> Floki.text()
  end

  defp extract_company_name(parsed) do
    parsed
    |> Floki.find(".data-display-header_info-content .data-details span")
    |> Enum.at(0)
    |> Floki.text()
  end

  defp extract_description(parsed) do
    parsed
    |> Floki.find("#jdp_description > .col-2 > .col.big.col-mobile-full")
    |> Floki.raw_html()
  end

  defp extract_title(parsed) do
    parsed
    |> Floki.find(".data-display-header_info-content h1:not(.loading)")
    |> Floki.text()
    |> String.trim()
  end
end