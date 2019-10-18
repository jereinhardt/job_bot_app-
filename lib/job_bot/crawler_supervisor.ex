defmodule JobBot.CrawlerSupervisor do
  alias JobBot.Source

  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(module, opts) do
    user_id = Map.get(opts, :user_id)
    ref = JobBot.Crawler.ref(user_id, module)
    spec = Supervisor.Spec.worker(module, [opts], restart: :temporary, id: ref)
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @doc """
  Start a crawler processes to create listings for a job search
  """
  def start_crawlers(job_search) do
    Enum.each(job_search.sources, fn (source) ->
      normalized_source =
        case source do
          %Source{} -> source
          source_name -> Source.find_by_name(source_name)
        end

      start_child(normalized_source.crawler, job_search)
    end)
  end
end