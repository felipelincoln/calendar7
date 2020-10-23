defmodule Calendar7Web.EventLive.MonthComponent do
  use Calendar7Web, :live_component

  alias Calendar7.Manage

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_calendar()

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Manage.get_event!(id)
    {:ok, _} = Manage.delete_event(event)

    {:noreply, assign_calendar(socket)}
  end

  defp assign_calendar(socket), do: assign_calendar(socket, socket.assigns.date)
  defp assign_calendar(socket, date), do: assign(socket, :events, list_events(date))

  defp list_events(date) do
    Manage.list_events(from: date, to: next_month(date))
  end

  defp prev(date) do
    date
    |> prev_month()
    |> Date.to_string()
  end
  defp next(date) do
    date
    |> next_month()
    |> Date.to_string()
  end
  defp next_month(%Date{month: 12, year: year} = date), do: %{date | month: 1, year: year+1}
  defp next_month(%Date{month: month} = date), do: %{date | month: month+1}
  defp prev_month(%Date{month: 1, year: year} = date), do: %{date | month: 12, year: year-1}
  defp prev_month(%Date{month: month} = date), do: %{date | month: month-1}
  defp days_in_month(date), do: Date.days_in_month(date)
  defp first_day_of_week(date), do: %{date | day: 1} |> Date.day_of_week()

  defp day(date, 0, weekday) do
    day = weekday - first_day_of_week(date) + 1
    if day > 0, do: day, else: 0
  end
  defp day(date, week, weekday) do 
    day = week*7 + weekday - first_day_of_week(date) + 1
    if day <= days_in_month(date), do: day, else: 0
  end

  defp month_name(n) do
    case n do
      1 -> "January"
      2 -> "February"
      3 -> "March"
      4 -> "April"
      5 -> "May"
      6 -> "June"
      7 -> "July"
      8 -> "August"
      9 -> "September"
      10 -> "October"
      11 -> "November"
      12 -> "December"
    end
  end
end
