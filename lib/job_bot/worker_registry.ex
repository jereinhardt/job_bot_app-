defmodule JobBot.WorkerRegistry do
  @moduledoc """
  A registry of all of the currently running web crawlers.  Saves records as
  a list of tuples, containing the crawler process, the crawler module, and
  the job search id.

  {pid, module, job_search_id}
  """

  use Agent

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc """
  Adds a process to the registry
  """
  def register({_scope, {module, job_search_id}}, pid) do
    ref = {pid, module, job_search_id}
    Agent.update(__MODULE__, fn state -> Enum.concat(state, [ref]) end)
  end

  @doc """
  Removes a process from the registry
  """
  def unregister(target_pid) do
    process = find_process(target_pid)

    Agent.update(
      __MODULE__,
      fn state -> Enum.reject(state, &(&1 == process)) end
    )
  end

  @doc """
  Return the job search id associated with a process
  """
  def job_search_id(target_pid) do
    {_pid, _module, job_search_id} = find_process(target_pid)
    job_search_id
  end

  defp find_process(target_pid) do
    Agent.get(__MODULE__, fn state -> 
      Enum.find(state, fn ({pid, _, _}) -> pid == target_pid end)
    end)
  end
end