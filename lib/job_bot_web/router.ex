defmodule JobBotWeb.Router do
  use JobBotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_id_cookie
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :data do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  pipeline :authenticate_user do
    plug JobBot.Accounts.Pipeline
  end

  scope "/", JobBotWeb do
    pipe_through [:browser, :authenticate_user] # Use the default browser stack

    get "/", PageController, :index
    delete "/session", SessionController, :delete
    resources "/session", SessionController, only: [:create]
    resources "/uploads", UploadController, only: [:create]
  end

  scope "/data", JobBotWeb do
    pipe_through [:data, :authenticate_user]

    get "/users", UsersController, :show
    resources "/users", UsersController, only: [:create]
    resources "/sources", SourceController, only: [:index]
    resources "/job_searches", JobSearchesController, only: [:create]
  end

  defp put_user_id_cookie(conn, _params) do
    if conn.cookies["user_id"] do
      conn
    else
      user_id = :crypto.strong_rand_bytes(10)
        |> Base.url_encode64()
        |> binary_part(0, 10)
      put_resp_cookie(conn, "user_id", user_id, max_age: 1_209_600)
    end
  end

  defp put_user_token(conn, _params) do
    unless conn.assigns[:user_id] do
      user_id = conn.cookies["user_id"] || conn.cookies["user_id"][:value]
      token = Phoenix.Token.sign(conn, "user socket", user_id)
      conn
        |> assign(:user_token, token)
        |> assign(:user_id, user_id)
    else
      conn
    end
  end
end