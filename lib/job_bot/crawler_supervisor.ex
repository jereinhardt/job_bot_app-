defmodule JobBot.CrawlerSupervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(module, opts) do
    user_id = Keyword.get(opts, :user_id)
    ref = JobBot.Crawler.ref(user_id, module)
    spec = Supervisor.Spec.worker(module, [opts], restart: :temporary, id: ref)
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @doc """
    First registers the user.  Then, starts a crawler process for each selected
    source for which the user provided information.
  """
  def start_crawlers(opts) do
    import Supervisor.Spec


    user_id = Keyword.get(opts, :user_id)
    searched_for_at = NaiveDateTime.utc_now()
    data = opts
      |> Keyword.drop([:user_id])
      |> Keyword.merge(searched_for_at: searched_for_at)
    JobBot.UserRegistry.register(user_id, data)

    opts
    |> Keyword.get(:sources, [])
    |> Enum.each(fn (source) -> start_child(source.crawler, opts) end)
  end
end