defmodule JobBotWeb.JobSearchesController do
  use JobBotWeb, :controller

  def create(conn, params) do
    opts = Map.to_list(params)
    JobBot.CrawlerSupervisor.start_crawlers(opts)
    conn
    |> put_status(:created)
    |> render("create.json")
  end
end