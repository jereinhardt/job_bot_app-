defmodule JobBot.Crawler.LinkedinTest do
  use JobBot.CrawlerCase

  alias HTTPoison.{Error, Response}
  alias JobBot.Listing
  alias JobBot.Crawler.Linkedin, as: Crawler

  import Mock

  @base_url "https://www.linkedin.com"

  describe "get_job_urls/1" do
    test "crawls the index for all jobs when a location is given" do
      with_mock(HTTPoison, [get: fn (_, _, _) -> get_fixture_response("index.html") end]) do
        terms = "Robotics Expert"
        location = "Earth"
        http_opts = [params: %{keywords: terms, location: location}]

        urls = Crawler.get_job_urls(%{terms: terms, location: location})

        assert called HTTPoison.get(@base_url <> "/jobs/search", [], http_opts)
        assert urls == [@base_url <> "/job_1", @base_url <> "/job_2"]
      end
    end
  end

  describe "crawl_url_for_listing/1" do
    test "returns a tuple with a listing when the request is good" do
      with_mock(HTTPoison, [get: fn("/job_1") -> get_fixture_response("job_1.html") end]) do
        expected_listing = %Listing{
          application_url: "apply_here.html",
          city: "Kansas City, MO",
          company_name: "Bottastic",
          title: "Bot Expert"
        }
        response = Crawler.crawl_url_for_listing("/job_1")

        assert listing_matches_response?(
          expected_listing,
          response,
          [:application_url, :city, :company_name, :title]
        )
      end
    end

    test "returns a tulple with an error message when the request is bad" do
      with_mock(
        HTTPoison,
        [get: fn("/job_1") -> {:error, %Error{reason: "Bad request"}} end]
      ) do
        url = "/job_1"
        reason = "Bad request"
        response = Crawler.crawl_url_for_listing(url)
        expected_message =
          "Error occured when trying to crawl url #{url}; REASON: #{reason}"

        assert response == {:error, expected_message}
      end
    end
  end
end