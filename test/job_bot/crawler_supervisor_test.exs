defmodule JobBot.CrawlerSupervisorTest do
  use ExUnit.Case

  alias JobBot.Crawler.WeWorkRemotely, as: Crawler

  import Mock

  test "start_crawlers/1 starts crawlers for sources and registers user" do
    with_mocks([{
      Supervisor, [], [start_child: fn(_mod, _child) -> nil end]
    }, {
      JobBot.UserRegistry, [], [register: fn(_id, _data) -> nil end]
    }]) do
      source = %JobBot.Source{
        crawler: Crawler,
        credentials: %{username: "username", password: "password"}
      }      
      user_id = 1
      opts = [user_id: user_id, sources: [source], name: "name"]
      data = Keyword.drop(opts, [:user_id])
      worker_opts = Enum.into(opts, credentials: source.credentials)
      child = Supervisor.Spec.worker(Crawler, worker_opts, restart: :temporary)

      JobBot.CrawlerSupervisor.start_crawlers(opts)

      assert called(Supervisor.start_child(JobBot.CrawlerSupervisor, child))
      assert called(JobBot.UserRegistry.register(user_id, data))
    end
  end
end