defmodule Calendar7Web.Pow.Routes do
  use Pow.Phoenix.Routes
  alias Calendar7Web.Router.Helpers, as: Routes

  @impl true
  def after_sign_out_path(conn) do
    IO.puts "go to homepage"
    Routes.event_index_path(conn, :index)
  end
end
