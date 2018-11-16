defmodule JobBot.CrawlerTest do
  use ExUnit.Case, async: true

  setup do
    defmodule TestCrawler do
      use JobBot.Crawler

      def get_job_urls(_opts), do: 1..2
      def crawl_url_for_listing(_url), do: {:ok, %JobBot.Listing{}}
    end

    %{crawler: TestCrawler}
  end

  test "ref/1 returns a genserver-copliant reference", %{crawler: crawler} do
    user_id = 1

    assert crawler.ref(user_id) == {:global, {crawler, user_id}}
  end
end