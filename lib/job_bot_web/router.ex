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

  pipeline :logged_in do
    plug JobBot.Plug.EnsureLoggedIn
  end

  pipeline :logged_out do
    plug JobBot.Plug.EnsureLoggedOut
  end



  scope "/", JobBotWeb do
    pipe_through [:browser, :live_browser]

    get "/search", JobSearchesController, :new
    get "/results", JobSearchesController, :show, as: :most_recent_search_results
  end

  scope "/", JobBotWeb do
    pipe_through [:browser, :live_browser, :logged_in]

    resources "/searches", JobSearchesController, only: [:show]
  end

  scope "/", JobBotWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", JobBotWeb do
    pipe_through [:browser, :logged_out]

    get "/signup", UsersController, :new, as: :signup
    resources "/users", UsersController, only: [:create]
    
    get "/login", SessionController, :new
    resources "/session", SessionController, only: [:create]
  end

  scope "/", JobBotWeb do
    pipe_through [:browser, :auth]

    resources "/session", SessionController, only: [:delete], singleton: true
  end
end