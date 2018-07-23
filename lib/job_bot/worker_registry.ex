defmodule JobBot.WorkerRegistry do
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
    Agent.update(
      __MODULE__,
      fn state -> Enum.reject(state, &(&1 == process)) end
    )
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
end