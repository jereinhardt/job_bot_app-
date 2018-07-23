defmodule JobBot.Crawler.WeWorkRemotely do
  use JobBot.Crawler

  import JobBot.Crawler.Helper

  alias HTTPoison.Response
  alias JobBot.Listing

  @base_url "https://weworkremotely.com"

  def get_job_urls(opts) do
    http_opts = if Keyword.get(opts, :terms) do
      [params: %{terms: Keyword.get(opts, :terms)}]
    else
      []      
    end
    url = @base_url <> "/remote-jobs/search"
    HTTPoison.get(url, [], http_opts) |> extract_urls_from_index()  
  end

  def crawl_url_for_listing(url) do
    case HTTPoison.get(url) do
      {:ok, %Response{status_code: 200, body: body}} ->
        parsed = Floki.parse(body)
        listing = extract_listing_data(parsed) |> Map.put(:listing_url, url)
        {:ok, listing}
      {:ok, %Response{status_code: code}} -> 
        message = "Failed to crawl job at #{url}, status code: #{code}"
        {:error, message}
      {:error, %HTTPoison.Error{reason: reason}} ->
        message = "Failed to connect to #{url}, reason: #{reason}"
        {:error, message}
    end
  end

  defp extract_urls_from_index({:ok, %Response{status_code: 200, body: body}}) do
    body
    |> Floki.parse()
    |> Floki.attribute(".jobs ul li a:not(.view-all)", "href")
    |> Enum.map(&relative_to_absolute_url(@base_url, &1))
  end

  defp extract_urls_from_index(_), do: []

  defp extract_listing_data(parsed) do
    %Listing{
      title: extract_title(parsed),
      city: extract_city(parsed),
      description: extract_description(parsed),
      remote: true,
      email: extract_email(parsed),
      company_name: extract_company_name(parsed),
      source: JobBot.Source.find_by_name("We Work Remotely"),
      application_url: extract_application_url(parsed)
    }    
  end

  defp extract_title(parsed) do
    parsed
      |> Floki.find(".listing-header-container h1")
      |> Floki.text()
  end

  defp extract_city(parsed) do
    parsed
      |> Floki.find(".listing-header-container .location")
      |> Floki.text()
  end

  defp extract_description(parsed) do
    parsed
      |> Floki.find(".job .listing-container")
      |> Floki.raw_html()
  end

  defp extract_email(parsed) do
    text = 
      parsed
      |> Floki.find(".apply p")
      |> Floki.text()
    if String.match?(text, ~r/(\w+)@([\w.]+)/) do
      i = 
        text
        |> String.split(~r/(\w+)@([\w.]+)/)
        |> Enum.at(0)
        |> String.length
      text
        |> String.split_at(i)
        |> Tuple.to_list()
        |> Enum.at(1)
        |> String.split(" ")
        |> Enum.at(0)
    else
      nil
    end
  end

  defp extract_company_name(parsed) do
    parsed
      |> Floki.find(".listing-header-container .company")
      |> Floki.text()
  end

  defp extract_application_url(parsed) do
    parsed
      |> Floki.find(".apply")
      |> Floki.attribute("a", "href")
      |> Enum.at(0)
  end
end