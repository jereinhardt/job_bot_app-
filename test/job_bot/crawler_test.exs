defmodule JobBot.CrawlerTest do
  use ExUnit.Case, async: true
  use JobBotWeb.FactoryCase

  alias JobBot.JobSearches.Listing
  alias JobBot.ListingProcessor
  alias JobBot.WorkerRegistry

  import Mock

  setup do
    defmodule TestCrawler do
      use JobBot.Crawler

      def get_job_urls(_opts), do: 1..2
      def crawl_url_for_listing(_url), do: {:ok, %Listing{}}
    end

    %{crawler: TestCrawler}
  end

  test "ref/2 returns a genserver-copliant reference", %{crawler: crawler} do
    job_search_id = 1
    ref = {:global, {crawler, job_search_id}}

    assert JobBot.Crawler.ref(job_search_id, crawler) == ref
  end

  describe "crawl_next" do
    test "processes the returned listing", %{crawler: crawler} do
      with_mocks([
        {ListingProcessor, [], [process: fn(_listing, _job_search_id) -> nil end]},
        {WorkerRegistry, [], [job_search_id: fn(_) -> 1 end]}
      ]) do
        crawler.handle_info(:crawl_next, ["www.test-url.com"])

        assert_called(ListingProcessor.process(%Listing{}, 1))
      end
    end
  end
end