defmodule JobBotWeb.JobSearchesController do
  use JobBotWeb, :controller

  alias JobBot.Accounts
  alias JobBot.Accounts.ErrorHandler
  alias JobBot.Accounts.Guardian
  alias JobBot.Accounts.User
  alias JobBot.JobSearches
  alias JobBot.JobSearches.JobSearch
  alias JobBotWeb.JobSearchesLive.New
  alias JobBotWeb.JobSearchesLive.Show

  def new(conn, _) do
    user = Map.get(conn.assigns, :current_user)
      
    live_render(conn, New, session: %{user: user})
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
        conn
        |> ErrorHandler.auth_error(
          {:unauthorized, "You don't have permission to view this page"},
          []
        )
    end
  end

  def show(conn, %{"id" => id}) do
    with %User{} = user <- Map.get(conn.assigns, :current_user),
      %JobSearch{} = job_search <- JobSearches.get(user, id)
    do
      live_render(
        conn,
        Show,
        session: %{job_search: job_search, current_user: user}
      )
    else
      _ -> render(conn, JobBotWeb.ErrorView, "404.html")
    end
  end

  def show(conn, _) do
    with %User{} = user <- Map.get(conn.assigns, :current_user),
      %JobSearch{} = job_search <- JobSearches.get_most_recent!(user)
    do
      live_render(
        conn,
        Show,
        session: %{job_search: job_search, current_user: user}
      )
    else
      nil -> redirect(conn, to: job_searches_path(conn, :new))
    end
  end
end