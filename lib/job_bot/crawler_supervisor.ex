defmodule JobBot.CrawlerSupervisor do
  use Supervisor

  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
  end

  @doc """
    First registers the user.  Then, starts a crawler process for each selected
    source for which the user provided information.
  """
  def start_crawlers(opts) do
    import Supervisor.Spec

    user_id = Keyword.get(opts, :user_id)
    data = Keyword.drop(opts, [:user_id])
    JobBot.UserRegistry.register(user_id, data)

    opts
    |> Keyword.get(:sources, [])
    |> Enum.each(fn (source) ->
      worker_opts = Enum.into(opts, credentials: source.credentials)
      child = worker(source.crawler, worker_opts, restart: :temporary)
      Logger.info "STARTING CHILD FOR #{source.crawler}"
      Supervisor.start_child(__MODULE__, child)
    end)
  end
end