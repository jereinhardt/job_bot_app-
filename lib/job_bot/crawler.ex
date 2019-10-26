defmodule JobBot.Crawler do
  @callback get_job_urls(map) :: list
  @callback crawl_url_for_listing(String.t) :: {:ok, map} | {:error, String.t}

  alias JobBot.JobSearches.Listing

  @doc """
  returns the formatted tuple to register the the process as a Genserver
  with a unique id associated with the job search.
  """
  def ref(job_search_id, module), do: {:global, {module, job_search_id}}

  defmacro __using__(_) do
    quote do
      use GenServer
      require Logger
      import JobBot.Crawler

      @behaviour JobBot.Crawler

      def start_link(job_search) do
        GenServer.start_link(__MODULE__, {:ok, job_search}, name: ref(job_search.id))
      end

      @doc """
      There are certain setup tasks that need to be performed before starting
      the crawler.  However, since these tasks are expensive, they will be
      performed in a continue callback so the process, and the parent
      supervisor, aren't tied up while setup is being performed.
      """
      def init({:ok, job_search}) do
        Logger.info(
          IO.ANSI.magenta <> "Starting crawler #{__MODULE__}" <> IO.ANSI.reset
        )
        {:ok, nil, {:continue, {:perform_setup, job_search}}}
      end

      @doc """
      Performs the following setup steps before crawling:
        1. Register the process with the WorkerRegistry
        2. Send an asyncronous call to self to schedule the first crawl job
        3. Crawl the index of the source for the listing urls, and set those
           urls as the initial state of the process

      Right now, the amount of links the crawler is allowed to return from the
      index is limitted to the first 10.  This is to prevent an overload of
      requests to the target service's servers.
      """
      def handle_continue({:perform_setup, job_search}, nil) do
        job_search.id
        |> ref()
        |> JobBot.WorkerRegistry.register(self())

        state =
          Task.async(fn -> get_job_urls(job_search) end)
          |> Task.await(30000)
          |> Enum.take(10)

        schedule_next_crawl()

        {:noreply, state}
      end

      @doc """
        Waits 5 seconds before crawling the next url
      """
      def schedule_next_crawl do
        Process.send_after(self(), :crawl_next, 5000)
      end

      @doc """
      Process the next url listed in the process's current state.  First
      checks to see if a listing with the same listing_url exists.  If so, it 
      processes that listing.  If not, then it crawls the url to build a new 
      listing.  Once the listing information is returned, it sends the listing
      to the Processor, then schedules the next crawl job.
      """
      def handle_info(:crawl_next, [url|state]) do
        url
        |> crawl_url_for_listing()
        |> process_listing()

        schedule_next_crawl()

        {:noreply, state}
      end

      @doc """
      Once all of the urls have been crawled, the process stops itself
      """
      def handle_info(:crawl_next, []), do: {:stop, :normal, []}

      @doc """
        If the setup has not been completed yet, queue another delayed scraper.
      """
      def handle_info(:crawl_next, nil) do
        Logger.info(
          IO.ANSI.green <> "no initial state yet.  Resetting inittial crawl" <> IO.ANSI.reset
        )
        schedule_next_crawl()
      end

      @doc """
      GenServer.terminate/2 callback.  Remove this process from the JobBot
      WorkerRegistry before stopping.
      """
      def terminate(_reason, _state) do
        JobBot.WorkerRegistry.unregister(self())
      end

      defp ref(job_search_id), do: ref(job_search_id, __MODULE__)
      
      defp job_search_id, do: JobBot.WorkerRegistry.job_search_id(self())

      defp process_listing({:ok, listing}) do
        JobBot.ListingProcessor.process(listing, job_search_id())
      end

      defp process_listing({:error, message}) do
        Logger.info IO.ANSI.red <> message <> IO.ANSI.reset
      end
    end
  end
end