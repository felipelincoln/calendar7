defmodule Calendar7Web.EventLive.Helpers do
  def month_name(n) do
    case n do
      1 -> "january"
      2 -> "february"
      3 -> "march"
      4 -> "april"
      5 -> "may"
      6 -> "june"
      7 -> "july"
      8 -> "august"
      9 -> "september"
      10 -> "october"
      11 -> "november"
      12 -> "december"
    end
  end

  def week_name(datetime) do
    datetime
    |> Date.day_of_week()
    |> case do
      1 -> "Mon"
      2 -> "Tues"
      3 -> "Wed"
      4 -> "Thurs"
      5 -> "Fri"
      6 -> "Sat"
      7 -> "Sun"
    end
  end
end
