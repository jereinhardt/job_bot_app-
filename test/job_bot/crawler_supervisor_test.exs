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
    "start_child/2 starts the given crawler with the given opts",
    %{job_search: job_search}
  ) do
    with_mock(DynamicSupervisor, [start_child: fn (_, _) -> nil end]) do
      ref = JobBot.Crawler.ref(job_search.id, Crawler)
      spec = Supervisor.Spec.worker(
        Crawler,
        [job_search],
        restart: :temporary,
        id: ref
      )

      JobBot.CrawlerSupervisor.start_child(Crawler, job_search)

      assert_called(
        DynamicSupervisor.start_child(JobBot.CrawlerSupervisor, spec)
      )
    end
  end

  test(
    "start_crawlers/1 starts crawlers for sources and registers user",
    %{job_search: job_search}
  ) do
    with_mock(DynamicSupervisor, [start_child: fn(_, _) -> nil end]) do
      ref = JobBot.Crawler.ref(job_search.id, Crawler)
      spec = Supervisor.Spec.worker(
        Crawler,
        [job_search],
        restart: :temporary,
        id: ref
      )

      JobBot.CrawlerSupervisor.start_crawlers(job_search)

      assert_called(
        DynamicSupervisor.start_child(JobBot.CrawlerSupervisor, spec)
      )
    end
  end
end