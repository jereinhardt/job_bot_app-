defmodule JobBotWeb.SourceController do
  use JobBotWeb, :controller

  def index(conn, _params) do
    sources = JobBot.Source.all() |> Poison.encode!()
    render conn, "index.json", sources: sources
  end
end