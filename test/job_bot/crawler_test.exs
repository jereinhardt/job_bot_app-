defmodule JobBot.CrawlerTest do
  use ExUnit.Case, async: true
  use JobBotWeb.FactoryCase

  alias JobBot.ListingProcessor
  alias JobBot.WorkerRegistry

  import Mock

  setup do
    defmodule TestCrawler do
      use JobBot.Crawler

      def get_job_urls(_opts), do: 1..2
      def crawl_url_for_listing(_url), do: {:ok, %JobBot.Listing{}}
    end

    %{crawler: TestCrawler}
  end

  test "ref/2 returns a genserver-copliant reference", %{crawler: crawler} do
    user_id = 1

    assert JobBot.Crawler.ref(user_id, crawler) == {:global, {crawler, user_id}}
  end

  describe "crawl_next" do
    test(
      "when a listing with that url exists, it uses that listing",
      %{crawler: crawler}
    ) do
      with_mocks([
        {ListingProcessor, [], [process: fn(_listing, _user_id) -> nil end]},
        {WorkerRegistry, [], [user_id: fn(_) -> 1 end]}
      ]) do
        url = "www.test-url.com"
        listing = insert(:listing, listing_url: url)

        crawler.handle_info(:crawl_next, [url])

        assert_called(ListingProcessor.process(listing, 1))
      end
    end
  end
end