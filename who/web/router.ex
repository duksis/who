defmodule Who.Router do
  use Who.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Who do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :index
    get "/logout", SessionController, :destroy
    get "/authenticate", SessionController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Who do
  #   pipe_through :api
  # end
end
