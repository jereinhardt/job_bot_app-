defmodule JobBot.WorkerRegistryTest do
  use ExUnit.Case, async: true

  alias JobBot.WorkerRegistry, as: Registry
  alias JobBot.Crawler.WeWorkRemotely, as: Crawler

  import Mock

  setup do
    Agent.update(Registry, fn (_) -> [] end)
    {:ok, worker} = Agent.start_link(fn -> [] end)
    %{worker: worker}
  end

  test "register/2 adds a process to the registry", %{worker: worker} do
    user_id = 1
    item = {worker, Crawler, user_id}
    Registry.register({:global, {Crawler, user_id}}, worker)
    retrieved = Agent.
      get(Registry, fn state -> Enum.find(state, &(&1 == item)) end)

    assert retrieved == item
  end


  test "unregister/1 removes the process", %{worker: worker} do
    with_mock(JobBot.UserRegistry, [unregister: fn(_id) -> nil end]) do
      user_id = 1
      item = {worker, Crawler, user_id}
      Registry.register({:global, {Crawler, user_id}}, worker)

      retrieved = Agent.
        get(Registry, fn state -> Enum.find(state, &(&1 == item)) end)

      assert retrieved == item

      Registry.unregister(worker)

      retrieved = Agent.
        get(Registry, fn state -> Enum.find(state, &(&1 == item)) end)

      assert retrieved == nil
      assert called(JobBot.UserRegistry.unregister(user_id))
    end 
  end


  test(
    "user_id/1 returns the user id associated with the process",
    %{worker: worker}
  ) do
    user_id = 1
    Registry.register({:global, {Crawler, user_id}}, worker)

    assert Registry.user_id(worker) == user_id
  end
end