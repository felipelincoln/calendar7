defmodule Calendar7Web.EventLive.Index do
  use Calendar7Web, :live_view

  alias Calendar7.Manage
  alias Calendar7.Manage.Event
  alias Calendar7Web.Credentials

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Manage.subscribe()
    current_user =
      case Credentials.get_user(socket, session) do
        nil -> nil
        user -> user.id
      end

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:calendar_id, 0)
    {:ok, socket}
  end

  # handle modals

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)
      |> assign_date(params)

    {:noreply, socket}
  end

  defp assign_date(socket, %{"date" => date_str}) do
    case Date.from_iso8601(date_str) do
      {:ok, date} -> 
        assign(socket, :date, %{date | day: 1})
      {:error, _reason} ->
        assign_date(socket, %{})
    end
  end

  defp assign_date(socket, _params) do
    date =
      Date.utc_today()
      |> Map.replace!(:day, 1)

    assign(socket, :date, date)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Manage.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Manage your events")
    |> assign(:event, nil)
  end


  # broadcast refresh calendar component

  @impl true
  def handle_info({:event_created, _event}, socket) do
    {:noreply, assign_calendar_new_id(socket)}
  end

  @impl true
  def handle_info({:event_updated, _event}, socket) do
    {:noreply, assign_calendar_new_id(socket)}
  end

  @impl true
  def handle_info({:event_deleted, _event}, socket) do
    {:noreply, assign_calendar_new_id(socket)}
  end

  defp assign_calendar_new_id(socket) do
    calendar_id = socket.assigns.calendar_id
    assign(socket, :calendar_id, calendar_id + 1)
  end
end
