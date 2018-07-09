defmodule JobBotWeb.Router do
  use JobBotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JobBotWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/uploads", UploadController, only: [:create]
  end

  scope "/api", JobBotWeb do
    pipe_through :api

    resources "/listings", ListingController
    resources "/sources", SourceController, only: [:index]
  end
end