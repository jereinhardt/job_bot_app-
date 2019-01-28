defmodule JobBot.WorkerRegistry do
  @moduledoc """
    A registry of all of the currently running web crawlers.  Saves records as
    a list of tuples, containing the crawler process, the crawler module, and
    the user id.  ex: {pid, module, user_id}
  """

  use Agent

  def start_link(opts \\ []) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc "Adds a process to the registry"
  def register({_scope, {module, user_id}}, pid) do
    ref = {pid, module, user_id}
    Agent.update(__MODULE__, fn state -> Enum.into(state, [ref]) end)
  end

  @doc "Removes a process from the registry"
  def unregister(target_pid) do
    process = find_process(target_pid)
    {_pid,  _module, user_id} = process

    Agent.update(
      __MODULE__,
      fn state -> Enum.reject(state, &(&1 == process)) end
    )

    if user_id |> processes_registered_to_user() |> Enum.empty?() do
      JobBot.UserRegistry.unregister(user_id)
    end
  end

  @doc "Return the user id associated with a process"
  def user_id(target_pid) do
    {_pid, _module, user_id} = find_process(target_pid)
    user_id
  end

  defp find_process(target_pid) do
    Agent.get(__MODULE__, fn state -> 
      Enum.find(state, fn ({pid, _module, _user}) -> pid == target_pid end)
    end)
  end

  defp processes_registered_to_user(user_id) do
    Agent.get(
      __MODULE__,
      fn (state) ->
        Enum.filter(state, fn({_, _, id}) -> user_id == id end)
      end
    )
  end
end