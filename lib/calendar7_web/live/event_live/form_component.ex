defmodule Calendar7Web.EventLive.FormComponent do
  use Calendar7Web, :live_component

  alias Calendar7.Manage

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Manage.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Manage.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    case Manage.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    event_params
    |> Map.put("user_id", socket.assigns.user_id)
    |> Manage.create_event()
    |> case do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp today(%Date{year: year, month: month}) do
    case DateTime.utc_now() do
      %{month: ^month, year: ^year} = now -> now
      now -> %{now | year: year, month: month, day: 1}
    end
  end

  defp tomorrow(date) do
    date
    |> today()
    |> DateTime.add(86400, :second)
  end
end
