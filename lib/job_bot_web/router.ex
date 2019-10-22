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

  pipeline :auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", JobBotWeb do
    pipe_through [:browser, :live_browser]

    get "/search", JobSearchesController, :new
    get "/results", JobSearchesController, :show, as: :most_recent_search_results
    resources "/search", JobSearchesController, only: [:show]
  end

  scope "/", JobBotWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/signup", UsersController, :new, as: :signup
    resources "/users", UsersController, only: [:create]
    
    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    resources "/session", SessionController, only: [:create, :delete]
  end
end