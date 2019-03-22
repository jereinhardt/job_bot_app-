defmodule JobBot.Crawler.WeWorkRemotelyTest do
  use JobBot.CrawlerCase

  alias HTTPoison.{Error, Response}
  alias JobBot.Listing
  alias JobBot.Crawler.WeWorkRemotely, as: Crawler

  import Mock

  @base_url "https://weworkremotely.com"
  @fixture_dir "test/support/fixtures/we_work_remotely/"
  
  describe "get_job_urls/1" do
    test "crawls the index for all jobs" do
      mocks = [
        get: fn(@base_url <> "/remote-jobs/search", _headers, _opts) ->
          get_fixture_response("index.html")
        end
      ]

      with_mock(HTTPoison, mocks) do
        urls = Crawler.get_job_urls(%{})

        assert called HTTPoison.get(@base_url <> "/remote-jobs/search", [], [])
        assert urls == ["#{@base_url}/job_1", "#{@base_url}/job_2"]
      end
    end

    test "crawls the index with the given params" do
      mocks = [
        get: fn(@base_url <> "/remote-jobs/search", _headers, _opts) ->
          get_fixture_response("index.html")
        end
      ]

      with_mock(HTTPoison, mocks) do
        search = "search terms"
        opts = [params: %{terms: search}]
        Crawler.get_job_urls(%{user_id: 1, terms: search})

        assert called HTTPoison.get(@base_url <> "/remote-jobs/search", [], opts)
      end
    end
  end

  describe "crawl_url_for_listing/1" do
    test "returns a tuple with a listing when the request is good" do
      mocks = [
        get: fn(url) ->
          case url do
            "/job_1" ->
              get_fixture_response("job_1.html")
            "/job_2" ->
              get_fixture_response("job_2.html")
          end
        end
      ]

      with_mock(HTTPoison, mocks) do
        expected_listing_1 = %Listing{
          title: "Experienced Backend Engineer",
          company_name: "Citrusbyte",
          email: nil,
          application_url: "http://careers.citrusbyte.com/apply/tPTZOv/" 
            <> "Experienced-Backend-Engineer?source=WWR"
        }
        expected_listing_2 = %Listing{
          title: "Software Engineer (Ruby on Rails)",
          company_name: "TaxJar",
          email: "jobs@taxjar.com",
          application_url: nil
        }
        fields = [:title, :company_name, :email, :application_url]

        response_1 = Crawler.crawl_url_for_listing("/job_1")
        response_2 = Crawler.crawl_url_for_listing("/job_2")

        assert listing_matches_response?(expected_listing_1, response_1, fields)
        assert listing_matches_response?(expected_listing_2, response_2, fields)
      end
    end

    test "returns an error message when the response is bad" do
      with_mock(
        HTTPoison,
        [get: fn(_) -> {:ok, %Response{status_code: 404}} end]
      ) do
        url = "url"
        message = "Failed to crawl job at #{url}, status code: 404"
        response = Crawler.crawl_url_for_listing(url)

        assert response == {:error, message}
      end
    end

    test "returns an error message when the request errors" do
      with_mock(
        HTTPoison,
        [get: fn(_) -> {:error, %Error{reason: :bad}} end])
      do
        url = "url"
        message = "Failed to connect to #{url}, reason: bad"
        response = Crawler.crawl_url_for_listing(url)

        assert response == {:error, message}
      end
    end
  end
end