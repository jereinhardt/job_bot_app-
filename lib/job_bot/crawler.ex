defmodule JobBot.Crawler do
  @callback get_job_urls(list) :: list
  @callback crawl_url_for_listing(String.t) :: {:ok, map} | {:error, String.t} # {:ok, Listing.t}

  defmacro __using__(opts) do
    use_hound = Keyword.get(opts, :use_hound, false)

    quote do
      use GenServer
      require Logger

      if unquote(use_hound) do
        use Hound.Helpers
      end

      @behaviour JobBot.Crawler

      if unquote(use_hound) do
        defp start_hound_session do
          if Enum.any?(Hound.Session.active_sessions()) do
            Hound.end_session()
          end

          Hound.start_session(
            browser: "chrome",
            user_agent: :chrome,
            driver: %{
              chromeOptions: %{
                args: ["--headless"]
              }
            }
          )
        end
      end

      def start_link(_, args, opts \\ []) do
        user_id = Keyword.get(args, :user_id)
        GenServer.start_link(__MODULE__, opts, name: ref(user_id))
      end

      @doc """
        Performs the following setup steps before starting the process:
          1. Register the process with the WorkerRegistry
          2. Send an asyncronous call to self to schedule the first crawl job
          3. Crawl the index of the source for the listing urls, and set those
             urls as the initial state of the process
      """
      def init(opts) do
        Logger.info(
          IO.ANSI.magenta <> "Starting crawler #{__MODULE__}" <> IO.ANSI.reset
        )
        opts
        |> Keyword.get(:user_id)
        |> ref()
        |> JobBot.WorkerRegistry.register(self())

        task = Task.async(fn -> get_job_urls(opts) end)
        state = Task.await(task, 30000)
        schedule_next_crawl()
        {:ok, state}
      end

      @doc """
        Waits a random amount of time between 5 and 8 seconds before crawling
        the next url
      """
      def schedule_next_crawl do
        wait = :rand.uniform(8) * 1000
        Process.send_after(self(), :crawl_next, wait)
      end

      @doc """
        Crawls the next url listed in the process's current state.  Once the
        listing information is returned, it sends the listing to the Processor,
        then schedules the next crawl job.
      """
      def handle_info(:crawl_next, [url|state]) do
        crawl_url_for_listing(url) |> process_listing()
        schedule_next_crawl()
        
        {:noreply, state}
      end

      @doc """
        once all of the urls have been crawled, the process stops itself
      """
      def handle_info(:crawl_next, []), do: GenServer.call(self(), :stop)

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

      @doc """
        returns the formatted tuple to register the the process as a Genserver
        with a unique id associated with the current user.
      """
      def ref(user_id), do: {:global, {__MODULE__, user_id}}
      
      defp user_id, do: JobBot.WorkerRegistry.user_id(self())

      defp process_listing({:ok, listing}) do
        JobBotWeb.Endpoint.broadcast(
          "users:#{user_id()}",
          "new_listing",
          %{"listing" => listing}
        )
      end

      defp process_listing({:error, message}) do
        Logger.info IO.ANSI.red <> message <> IO.ANSI.reset
      end
    end
  end
end