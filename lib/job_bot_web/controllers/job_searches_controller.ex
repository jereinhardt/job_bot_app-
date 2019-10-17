defmodule JobBotWeb.JobSearchesController do
  use JobBotWeb, :controller

  alias JobBot.Accounts
  alias JobBot.Accounts.Guardian

  plug :create_user_session

  def new(conn, _) do
    user = Map.get(conn.assigns, :current_user)
      
    live_render(conn, JobBotWeb.JobSearchesLive.New, session: %{user: user})
  end

  def show(conn, %{"user_token" => token} = params) do
    case Guardian.verify_signed_token(token) do
      {:ok, user_id} ->
        user = Accounts.get_user!(user_id)
        params = Map.delete(params, "user_token")
        conn
        |> Accounts.login(user)
        |> show(params)
      {:error, _} ->
        # TODO render unauthorized response
    end
  end

  def show(conn, %{"id" => id}) do
    job_search = Accounts.get_job_search!(id)
    render(conn, "show.html", job_search: job_search)
  end

  def show(conn, %{"id" => id}) do
    # TODO Show a specific search
  end

  def show(conn, _) do
    user = Map.get(conn.assigns, :current_user)
      
    {:ok, job_search} = Accounts.most_recent_job_search(user)
    render(conn, "show.html", job_search: job_search)
  end


  # Delete everything below here maybe

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