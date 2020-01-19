defmodule JobBot.Crawler do
  alias JobBot.JobSearches.{JobSearch, Listing}

  @callback crawl_job_search_index(JobSearch.t) :: list(Listing.t)
  @callback crawl_listing(Listing.t) :: {:ok, Listing.t} | {:error, String.t}

  @doc """
  returns the formatted tuple to register the the process as a Genserver
  with a unique id associated with the job search.
  """
  def ref(job_search_id, module), do: {:global, {module, job_search_id}}

  defmacro __using__(opts) do
    base_url = Keyword.get(opts, :base_url)
    source_name = Keyword.get(opts, :source_name)

    quote do
      use GenServer
      require Logger
      import JobBot.Crawler
      import JobBot.Crawler.Request

      @behaviour JobBot.Crawler

      @base_url unquote(base_url)
      @source_name unquote(source_name)

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
        2. Crawl the index of search results and parse a list of listings.  This is
           generate an initial list of listings that can be parsed from whatever
           information is available from the index.  Later, the crawler will try
           to search each individual listing to get more information, and update the
           listing if possible.  However, if the site's ROBOTS.txt does not allow
           crawling of some or all listings, those crawls will be skipped, and the
           initial listing that was parsed from the index will be saved.
        3. Send an asyncronous call to self to schedule the worker to crawl the
           first listing returned from crawl_job_search_index/1

      Right now, the amount of links the crawler is allowed to return from the
      index is limitted to the first 10.  This is to prevent an overload of
      requests to the target service's servers.
      """
      def handle_continue({:perform_setup, job_search}, nil) do
        job_search.id
        |> ref()
        |> JobBot.WorkerRegistry.register(self())

        state =
          Task.async(fn -> crawl_job_search_index(job_search) end)
          |> Task.await(30000)

        schedule_next_crawl()

        {:noreply, state}
      end

      @doc """
      Waits 5 seconds before crawling the next url
      """
      def schedule_next_crawl do
        case check_rate_limit() do
          :ok ->
            Process.send(self(), :crawl_next, [])
          {:wait, wait_time} ->
            Process.send_after(self(), :crawl_next, wait_time)
        end
      end

      @doc """
      Process the next url listed in the process's current state.  First
      checks to see if a listing with the same listing_url exists.  If so, it 
      processes that listing.  If not, then it crawls the url to build a new 
      listing.  Once the listing information is returned, it sends the listing
      to the Processor, then schedules the next crawl job.
      """
      def handle_info(:crawl_next, [listing|state]) do
        with {:ok, response} <- find_final_request_response(listing.listing_url),
          true <- crawlable?(response.request_url)
        do
          listing
          |> crawl_listing()
          |> process_listing()
        else
          _ -> process_listing(listing)
        end

        schedule_next_crawl()

        {:noreply, state}
      end

      @doc """
      Once all of the urls have been crawled, the process stops itself
      """
      def handle_info(:crawl_next, []), do: {:stop, :normal, []}


      @doc """
      Checks to see if the crawl rate has been reached.  If it has, it waits the
      appropriate amount of time before starting the next crawl.  Otherwise, the
      next crawl is started immediately.
      """
      def schedule_next_crawl do
        case check_rate_limit() do
          :ok ->
            Process.send(self(), :crawl_next, [])
          {:wait, wait_time} ->
            Process.send_after(self(), :crawl_next, wait_time)
        end
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

      defp check_rate_limit() do
        bucket_name = Atom.to_string(__MODULE__)
        
        case ExRated.check_rate(bucket_name, 10_000, 5) do
          {:ok, _} -> :ok
          {:error, _} ->
            {_, _, wait_time, _, _} =
              ExRated.inspect_bucket(bucket_name, 10_000, 5)
            {:wait, wait_time}
        end
      end

      defp crawlable?(url) do
        %{path: path, query: query} = URI.parse(url)

        disallowed_path_found =
          parsed_robots_txt
          |> Enum.filter(fn ({key, _}) -> key == "Disallow" end)
          |> Enum.find(fn ({_, disallowed_path}) ->
            crawl_path = if query, do: "#{path}?", else: path
            crawl_path == disallowed_path
          end)

        !disallowed_path_found
      end

      defp parsed_robots_txt do
        {:ok, res} = HTTPoison.get("#{@base_url}/robots.txt")
        if res.status_code == 404 do
          []
        else
          res.body
          |> String.split("\n\n")
          |> Enum.find(&String.starts_with?(&1, "User-agent: *"))
          |> String.split("\n")
          |> Enum.map(fn (string) ->
            [key, value] = String.split(string, ":")
            {key, String.trim(value)}
          end)
        end
      end

      defp process_listing(%Listing{} = listing) do
        JobBot.ListingProcessor.process(listing, job_search_id())
      end

      defp process_listing({:ok, listing}) do
        JobBot.ListingProcessor.process(listing, job_search_id())
      end

      defp process_listing({:error, message}) do
        Logger.info IO.ANSI.red <> message <> IO.ANSI.reset
      end

      defp check_rate_limit() do
        bucket_name = Atom.to_string(__MODULE__)
        
        case ExRated.check_rate(bucket_name, 10_000, 5) do
          {:ok, _} -> :ok
          {:error, _} ->
            {_, _, wait_time, _, _} =
              ExRated.inspect_bucket(bucket_name, 10_000, 5)
            {:wait, wait_time}
        end
      end
    end
  end
end