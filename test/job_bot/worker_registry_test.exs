defmodule JobBot.WorkerRegistryTest do
  use ExUnit.Case, async: true

  alias JobBot.WorkerRegistry, as: Registry
  alias JobBot.Crawler.WeWorkRemotely, as: Crawler

  import Mock

  setup do
    Agent.update(Registry, fn (_) -> [] end)
    process = spawn(fn -> nil end)
    %{worker: process}
  end

  test "register/2 adds a process to the registry", %{worker: worker} do
    job_search_id = 1
    item = {worker, Crawler, job_search_id}
    Registry.register({:global, {Crawler, job_search_id}}, worker)
    retrieved = Agent.
      get(Registry, fn state -> Enum.find(state, &(&1 == item)) end)

    assert retrieved == item
  end


  test "unregister/1 removes the process", %{worker: worker} do
    job_search_id = 1
    item = {worker, Crawler, job_search_id}
    Registry.register({:global, {Crawler, job_search_id}}, worker)

    retrieved = 
      Agent.get(Registry, fn state -> Enum.find(state, &(&1 == item)) end)

    assert retrieved == item

    Registry.unregister(worker)

    retrieved =
      Agent.get(Registry, fn state -> Enum.find(state, &(&1 == item)) end)

    assert retrieved == nil
  end


  test(
    "job_search_id/1 returns the job search id associated with the process",
    %{worker: worker}
  ) do
    job_search_id = 1
    Registry.register({:global, {Crawler, job_search_id}}, worker)

    assert Registry.job_search_id(worker) == job_search_id
  end
end