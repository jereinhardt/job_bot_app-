defmodule JobBotWeb.JobSearchesControllerTest do
  use JobBotWeb.AuthCase

  import JobBot.Factory

  alias JobBot.Accounts.Guardian

  describe "show/2" do
    test "logs a user in when given a valid signed token", %{conn: conn} do
      user = insert(:user)
      token = Guardian.signed_token(user)
      path = most_recent_search_results_path(conn, :show)

      response = 
        conn
        |> get(path, %{"user_token" => token})

      assert redirected_to(response) == path
      assert response.assigns.current_user.id == user.id
    end

    test "redirects user to new search when they do not have any searches", %{conn: conn} do
      user = insert(:user)
      {:ok, conn: conn} = log_in_user(conn, user)
      path = most_recent_search_results_path(conn, :show)

      response =
        conn
        |> get(path)

      assert redirected_to(response) == job_searches_path(conn, :new)
    end

    test "renders an unauthorized error when given an invalid token", %{conn: conn} do
      token = "invalid token"
      path = most_recent_search_results_path(conn, :show)

      response =
        conn
        |> get(path, %{"user_token" => token})

      assert response.status == 401
    end

    test "shows the most recent search when no id is given", %{conn: conn} do
      user = insert(:user)
      job_search = insert(:job_search, user: user)
      listing = insert(:listing, job_search: job_search)
      {:ok, conn: conn} = log_in_user(conn, user)
      path = most_recent_search_results_path(conn, :show)

      response =
        conn
        |> get(path)
        |> html_response(200)

      assert response =~ listing.title
    end

    test "shows the specified search when the id is given", %{conn: conn} do
      user = insert(:user)
      job_search = insert(:job_search, user: user)
      listing = insert(:listing, job_search: job_search)
      {:ok, conn: conn} = log_in_user(conn, user)
      path = job_searches_path(conn, :show, job_search.id)

      response =
        conn
        |> get(path)
        |> html_response(200)

      assert response =~ listing.title    
    end
  end
end