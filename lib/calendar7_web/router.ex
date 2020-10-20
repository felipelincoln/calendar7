defmodule Calendar7Web.Router do
  use Calendar7Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Calendar7Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Calendar7Web do
    pipe_through :browser

    live "/", PageLive, :index

    live "/events", EventLive.Index, :index
    live "/events/new", EventLive.Index, :new
    live "/events/:id/edit", EventLive.Index, :edit

    live "/events/:id", EventLive.Show, :show
    live "/events/:id/show/edit", EventLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", Calendar7Web do
  #   pipe_through :api
  # end
end
