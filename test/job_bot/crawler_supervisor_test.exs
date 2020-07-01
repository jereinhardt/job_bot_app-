defmodule JobBot.CrawlerSupervisorTest do
  use ExUnit.Case
  use JobBotWeb.FactoryCase

  alias JobBot.Crawler.Monster, as: Crawler

  import Mock

  setup do
    job_search = insert(:job_search, sources: ["Monster"])
    %{job_search: job_search}
  end

  test(
    "start_child/2 starts the given crawler with the given job search",
    %{job_search: job_search}
  ) do
    with_mock(DynamicSupervisor, [start_child: fn (_, _) -> nil end]) do
      ref = JobBot.Crawler.ref(job_search.id, Crawler)
      
      spec = %{
        id: ref,
        start: {Crawler, :start_link, [job_search]},
        restart: :temporary,
        type: :worker
      }

      JobBot.CrawlerSupervisor.start_child(Crawler, job_search)

      assert_called(
        DynamicSupervisor.start_child(JobBot.CrawlerSupervisor, spec)
      )
    end
  end
end