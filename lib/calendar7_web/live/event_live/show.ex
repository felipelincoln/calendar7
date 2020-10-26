defmodule Calendar7Web.EventLive.Show do
  use Calendar7Web, :live_view

  import Calendar7Web.EventLive.Helpers
  alias Calendar7.Manage
  alias Calendar7Web.Credentials

  @impl true
  def mount(_params, session, socket) do
    current_user =
      case Credentials.get_user(socket, session) do
        nil -> nil
        user -> user
      end
    {:ok, assign(socket, :current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    ref_date = Map.get(params, "ref_date", "")
    user = socket.assigns.current_user
    event = Manage.get_event!(id)

    has_joined? =
      case user do
        nil -> nil
        user -> Manage.has_joined?(user, event)
      end

    {:noreply,
     socket
     |> assign(:ref_date, ref_date)
     |> assign(:event, Manage.get_event!(id))
     |> assign(:has_joined?, has_joined?)
    }
  end

  @impl true
  def handle_event("toggle_join", _value, socket) do
    user = socket.assigns.current_user
    event = socket.assigns.event

    has_joined? =
      case socket.assigns.has_joined? do
        true ->
          {:ok, _user} = Manage.leave_event(user, event)
          false
        false ->
          {:ok, _user} = Manage.join_event(user, event)
          true
      end

    msg = msg(has_joined?)

    socket =
      socket
      |> put_flash(:info, msg)
      |> assign(:has_joined?, has_joined?)

    {:noreply, socket}
  end

  defp msg(true), do: "You have joined this event!"
  defp msg(false), do: "You have left this event!"
end
