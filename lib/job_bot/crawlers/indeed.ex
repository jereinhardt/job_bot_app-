defmodule JobBot.Crawler.Indeed do
  use JobBot.Crawler

  import JobBot.Crawler.Helper

  alias HTTPoison.{Error, Response}
  alias JobBot.{Listing, Source}

  @base_url "https://www.indeed.com"

  def get_job_urls(%{location: nil}), do: []
  def get_job_urls(opts) do
    http_opts = [
      params: %{
        q: Map.get(opts, :terms),
        l: Map.get(opts, :location)
      }
    ]

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
    |> Floki.attribute("a.jobtitle, .jobtitle a", "href")
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
      source: Source.find_by_name("Indeed")
    }
  end

  defp extract_application_url(parsed) do
    parsed
    |> Floki.attribute("#viewJobButtonLinkContainer a", "href")
    |> Enum.at(0)
  end

  defp extract_city(parsed) do
    parsed
    |> Floki.find(".jobsearch-InlineCompanyRating")
    |> Floki.text()
    |> String.split("-")
    |> Enum.at(-1)
  end

  defp extract_company_name(parsed) do
    parsed
    |> Floki.find(".jobsearch-InlineCompanyRating")
    |> Floki.text()
    |> String.split("-")
    |> Enum.at(0)    
  end

  defp extract_description(parsed) do
    parsed
    |> Floki.find(".jobsearch-JobComponent-description")
    |> Floki.raw_html()
  end

  defp extract_title(parsed) do
    parsed
    |> Floki.find(".jobsearch-JobInfoHeader-title")
    |> Floki.text()
    |> String.split("-")
    |> Enum.at(0)    
  end
end