defmodule Calendar7Web.EventLive.Index do
  use Calendar7Web, :live_view

  alias Calendar7.Manage
  alias Calendar7.Manage.Event
  alias Calendar7Web.Credentials

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Manage.subscribe()
    current_user = Credentials.get_user(socket, session)
    socket =
      socket
      |> assign(:events, list_events())
      |> assign(:current_user, current_user)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Manage.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Manage.get_event!(id)
    {:ok, _} = Manage.delete_event(event)

    {:noreply, assign(socket, :events, list_events())}
  end

  @impl true
  def handle_info({:event_created, _event}, socket) do
    {:noreply, assign(socket, :events, list_events())}
  end

  @impl true
  def handle_info({:event_updated, _event}, socket) do
    {:noreply, assign(socket, :events, list_events())}
  end

  @impl true
  def handle_info({:event_deleted, _event}, socket) do
    {:noreply, assign(socket, :events, list_events())}
  end

  defp list_events do
    Manage.list_events()
  end
end
