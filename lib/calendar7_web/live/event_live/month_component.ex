defmodule Calendar7Web.EventLive.MonthComponent do
  use Calendar7Web, :live_component

  def mount(socket) do
    {:ok, assign(socket, :date, today())}
  end

  defp today, do: Date.utc_today()
  defp days_in_month(date), do: Date.days_in_month(date)
  defp first_day_of_week(date) do
    %{date | day: 1}
    |> Date.day_of_week()
  end

  defp day(date, 0, weekday) do
    day = weekday - first_day_of_week(date) + 1
    if day > 0, do: day, else: 0
  end
  defp day(date, week, weekday) do 
    day = week*7 + weekday - first_day_of_week(date) + 1
    if day <= days_in_month(date), do: day, else: 0
  end

end
