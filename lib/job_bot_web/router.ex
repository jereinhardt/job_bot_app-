defmodule JobBotWeb.Router do
  use JobBotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug JobBot.Accounts.Pipeline
  end

  pipeline :live_browser do
    plug Phoenix.LiveView.Flash
    plug :put_layout, {JobBotWeb.LayoutView, :app}    
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :data do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug JobBot.Accounts.Pipeline
  end

  pipeline :auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", JobBotWeb do
    pipe_through [:browser, :live_browser]

    get "/search", JobSearchesController, :new, as: :new_job_search
  end

  scope "/", JobBotWeb do
    pipe_through :browser

    get "/results", JobSearchesController, :show, as: :most_recent_search_results

    get "/", PageController, :index
    get "/signup", PageController, :index, as: :signup
    get "/login", PageController, :index, as: :login
    get "/logout", SessionController, :delete
    delete "/session", SessionController, :delete
    resources "/session", SessionController, only: [:create]
    get "/search/old", PageController, :index
    get "/results/old", PageController, :index
  end

  scope "/data", JobBotWeb do
    pipe_through :data

    resources "/users", UsersController, only: [:create]
    resources "/sources", SourceController, only: [:index]
  end

  scope "/data", JobBotWeb do
    pipe_through [:data, :auth]

    get "/users", UsersController, :show
    resources "/job_searches", JobSearchesController, only: [:create]
  end
end