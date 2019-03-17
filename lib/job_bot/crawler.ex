defmodule JobBot.Crawler do
  @callback get_job_urls(map) :: list
  @callback crawl_url_for_listing(String.t) :: {:ok, map} | {:error, String.t}

  alias JobBot.Listing

  @doc """
    returns the formatted tuple to register the the process as a Genserver
    with a unique id associated with the current user.
  """
  def ref(user_id, module), do: {:global, {module, user_id}}

  defmacro __using__(opts) do
    quote do
      use GenServer
      require Logger
      import JobBot.Crawler

      @behaviour JobBot.Crawler

      def start_link(opts) do
        user_id = Map.get(opts, :user_id)
        GenServer.start_link(__MODULE__, {:ok, opts}, name: ref(user_id))
      end

      @doc """
        There are certain setup tasks that need to be performed before starting
        the crawler.  However, since these tasks are expensive, they will be
        performed in a continue callback so the process, and the parent
        supervisor, aren't tied up while setup is being performed.
      """
      def init({:ok, opts}) do
        Logger.info(
          IO.ANSI.magenta <> "Starting crawler #{__MODULE__}" <> IO.ANSI.reset
        )
        {:ok, nil, {:continue, {:perform_setup, opts}}}
      end

      @doc """
        Performs the following setup steps before crawling:
          1. Register the process with the WorkerRegistry
          2. Send an asyncronous call to self to schedule the first crawl job
          3. Crawl the index of the source for the listing urls, and set those
             urls as the initial state of the process
      """
      def handle_continue({:perform_setup, opts}, nil) do
        opts
        |> Map.get(:user_id)
        |> ref()
        |> JobBot.WorkerRegistry.register(self())

        state = Task.async(fn -> get_job_urls(opts) end)
          |> Task.await(30000)
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
        |> crawl_url_for_listing_if_none_exists()
        |> process_listing()
        schedule_next_crawl()
        
        {:noreply, state}
      end

      @doc """
        Once all of the urls have been crawled, the process stops itself
      """
      def handle_info(:crawl_next, []), do: GenServer.call(self(), :stop)

      @doc """
        If the setup has not been completed yet, queue another delayed scraper.
      """
      def handle_info(:crawl_next, nil) do
        Logger.info(
          IO.ANSI.green <> "no initial state yet.  Resetting inittial crawl" <> IO.ANSI.reset
        )
        schedule_next_crawl()
      end

      @doc "Stops the process"
      def handle_call(:stop, _from, []), do: {:stop, :normal, []}
      
      @doc "In case there are still urls left to crawl, continue the crawl loop"
      def handle_call(:stop, _from, state) do
        schedule_next_crawl()
        {:reply, :ok, state}
      end

      @doc """
        GenServer.terminate/2 callback.  Remove this process from the JobBot
        WorkerRegistry before stopping.
      """
      def terminate(_reason, _state) do
        JobBot.WorkerRegistry.unregister(self())
      end

      defp crawl_url_for_listing_if_none_exists(url) do
        case Listing.find_existing_listing(url) do
          %Listing{} = listing -> {:ok, listing}
          nil -> crawl_url_for_listing(url)
        end
      end

      defp ref(user_id), do: ref(user_id, __MODULE__)
      
      defp user_id, do: JobBot.WorkerRegistry.user_id(self())

      defp process_listing({:ok, listing}) do
        JobBot.ListingProcessor.process(listing, user_id())
      end

      defp process_listing({:error, message}) do
        Logger.info IO.ANSI.red <> message <> IO.ANSI.reset
      end
    end
  end
end