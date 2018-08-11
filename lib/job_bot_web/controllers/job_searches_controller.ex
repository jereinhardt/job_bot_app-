defmodule JobBotWeb.JobSearchesController do
  use JobBotWeb, :controller

  def create(conn, params) do
    keyword_opts = params |> AtomicMap.convert(%{ignore: true}) |> Map.to_list()
    sources = 
      keyword_opts
      |> Keyword.get(:sources)
      |> Map.values()
    opts = Keyword.put(keyword_opts, :sources, sources)
    
    JobBot.CrawlerSupervisor.start_crawlers(opts)
    
    conn
    |> put_status(:created)
    |> render("create.json")
  end
end