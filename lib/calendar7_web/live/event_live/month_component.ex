defmodule Calendar7Web.EventLive.MonthComponent do
  use Calendar7Web, :live_component

  alias Calendar7.Manage

  @impl true
  def mount(socket) do
    IO.inspect socket.assigns

    date = %{today() | day: 1}
    {:ok, assign_calendar(socket, date)}
  end

  @impl true
  def handle_event("next", _, socket) do
    date = socket.assigns.date |> next_month()
    {:noreply, assign_calendar(socket, date)}
  end

  @impl true
  def handle_event("prev", _, socket) do
    date = socket.assigns.date |> prev_month()
    {:noreply, assign_calendar(socket, date)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Manage.get_event!(id)
    {:ok, _} = Manage.delete_event(event)

    {:noreply, assign_calendar(socket)}
  end

  defp assign_calendar(socket) do
    date = socket.assigns.date
    assign_calendar(socket, date)
  end

  defp assign_calendar(socket, date) do
    socket
    |> assign(:date, date)
    |> assign(:events, list_events(date))
  end

  defp list_events(date) do
    Manage.list_events(from: date, to: next_month(date))
  end

  defp next_month(%Date{month: 12, year: year} = date), do: %{date | month: 1, year: year+1}
  defp next_month(%Date{month: month} = date), do: %{date | month: month+1}
  defp prev_month(%Date{month: 1, year: year} = date), do: %{date | month: 12, year: year-1}
  defp prev_month(%Date{month: month} = date), do: %{date | month: month-1}
  defp today, do: Date.utc_today()
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
