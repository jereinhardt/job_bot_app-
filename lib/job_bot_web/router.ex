defmodule JobBotWeb.Router do
  use JobBotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug JobBot.Accounts.Pipeline
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :data do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug JobBot.Accounts.Pipeline
    plug :put_user_token
  end

  scope "/", JobBotWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/signup", PageController, :index
    get "/login", PageController, :index
    get "/logout", SessionController, :delete
    delete "/session", SessionController, :delete
    resources "/session", SessionController, only: [:create]
    resources "/uploads", UploadController, only: [:create]
  end

  scope "/data", JobBotWeb do
    pipe_through :data

    get "/users", UsersController, :show
    resources "/users", UsersController, only: [:create]
    resources "/user_listings", UserListingsController, only: [:update]
    resources "/sources", SourceController, only: [:index]
    resources "/job_searches", JobSearchesController, only: [:create]
  end

  defp put_user_token(conn, _params) do
    case Map.get(conn.assigns, :current_user, nil) do
      nil -> conn
      _ ->
        user_id = conn.assigns[:current_user].id
        token = Phoenix.Token.sign(conn, "user socket", user_id)
        assign(conn, :user_token, token)
    end
  end
end