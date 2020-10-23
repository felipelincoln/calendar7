defmodule Calendar7Web.EventLive.Show do
  use Calendar7Web, :live_view

  alias Calendar7.Manage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    ref_date = Map.get(params, "ref_date", "")

    {:noreply,
     socket
     |> assign(:ref_date, ref_date)
     |> assign(:event, Manage.get_event!(id))}
  end
end
