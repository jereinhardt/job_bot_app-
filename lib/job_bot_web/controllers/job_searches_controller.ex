defmodule JobBotWeb.JobSearchesController do
  use JobBotWeb, :controller
  plug Guardian.Plug.EnsureAuthenticated when action in [:create]

  def create(conn, params) do
    atomized_params = atomize(params)
    sources = 
      atomized_params
      |> Map.get(:sources)
      |> Map.values()
      |> Enum.map(&normalize_source/1)
    opts = Map.put(atomized_params, :sources, sources)

    JobBot.CrawlerSupervisor.start_crawlers(opts)
    
    conn
    |> put_status(:created)
    |> render("create.json")
  end

  defp normalize_source(source_map) do
    crawler = source_map |> Map.get(:crawler) |> String.to_atom()
    applier = source_map |> Map.get(:applier) |> String.to_atom()

    JobBot.Source.__struct__(source_map)
      |> Map.put(:crawler, crawler)
      |> Map.put(:applier, applier)
  end

  defp atomize(params) do
    params
    |> Enum.map(fn {key, value} ->
         key = if is_atom(key), do: key, else: String.to_atom(key)
         value = if is_map(value), do: atomize(value), else: value
         {key, value}
       end)
    |> Map.new()
  end
end