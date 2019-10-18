defmodule JobBotWeb.JobSearchesController do
  use JobBotWeb, :controller

  alias JobBot.Accounts
  alias JobBot.Accounts.Guardian
  alias JobBot.Accounts.User
  alias JobBot.JobSearches
  alias JobBot.JobSearches.JobSearch

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
        |> redirect(to: conn.request_path)
      {:error, _} ->
        # TODO render unauthorized response
    end
  end

  def show(conn, %{"id" => id}) do
    case JobSearches.get(id) do
      {:ok, job_search} -> render(conn, "show.html", job_search: job_search)
      _ -> # TODO: RENDER 404
    end    
  end

  def show(conn, %{"id" => id}) do
    # TODO Show a specific search
  end

  def show(conn, _) do
    with %User{} = user <- Map.get(conn.assigns, :current_user),
      %JobSearch{} = job_search <- JobSearches.get_most_recent!(user)
    do
      render(conn, "show.html", job_search: job_search)
    else
      nil -> redirect(conn, to: new_job_search_path(conn, :new))
    end
  end
end