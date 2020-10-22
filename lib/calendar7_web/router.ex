defmodule Calendar7Web.Router do
  use Calendar7Web, :router
  use Pow.Phoenix.Router

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: Pow.Phoenix.PlugErrorHandler
  end

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

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", Calendar7Web do
    pipe_through :browser

    live "/", EventLive.Index, :index
  end

  scope "/", Calendar7Web do
    pipe_through [:browser, :protected]

    live "/new", EventLive.Index, :new
    live "/:id/edit", EventLive.Index, :edit

    live "/:id", EventLive.Show, :show
    live "/:id/show/edit", EventLive.Show, :edit

  end

  # Other scopes may use custom stacks.
  # scope "/api", Calendar7Web do
  #   pipe_through :api
  # end
end
