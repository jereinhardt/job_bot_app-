defmodule JobBot.CrawlerSupervisorTest do
  use ExUnit.Case

  alias JobBot.Crawler.WeWorkRemotely, as: Crawler

  import Mock

  test "start_child/2 starts the given crawler with the given opts" do
    with_mock(DynamicSupervisor, [start_child: fn (_mod, _child) -> nil end]) do
      ref = JobBot.Crawler.ref(user_id(), Crawler)
      spec = Supervisor.Spec.worker(
        Crawler,
        [worker_opts()],
        restart: :temporary,
        id: ref
      )

      JobBot.CrawlerSupervisor.start_child(Crawler, worker_opts())

      assert called(DynamicSupervisor.start_child(JobBot.CrawlerSupervisor, spec))
    end
  end

  test "start_crawlers/1 starts crawlers for sources and registers user" do
    with_mocks([{
      DynamicSupervisor, [], [start_child: fn(_mod, _child) -> nil end]
    }, {
      JobBot.UserRegistry, [], [register: fn(_id, _data) -> nil end]
    }]) do
      data = Keyword.drop(opts(), [:user_id])
      ref = JobBot.Crawler.ref(user_id(), Crawler)
      spec = Supervisor.Spec.worker(
        Crawler,
        [worker_opts()],
        restart: :temporary,
        id: ref
      )

      JobBot.CrawlerSupervisor.start_crawlers(opts())

      assert called(DynamicSupervisor.start_child(JobBot.CrawlerSupervisor, spec))
      assert called(JobBot.UserRegistry.register(user_id(), data))
    end
  end

  defp user_id, do: 1

  defp opts do
    [user_id: user_id(), sources: [source()], name: "name"]
  end

  defp source do
    %JobBot.Source{
      crawler: Crawler,
      credentials: %{username: "username", password: "password"}
    }
  end 

  defp worker_opts do
    Keyword.merge(opts(), credentials: source().credentials)
  end
end