defmodule Calendar7Web.LayoutHelpers do
  @moduledoc false

  alias Calendar7.Repo
  alias Calendar7.Users.User

  def get_user(%User{id: id}), do: get_user(id)
  def get_user(id), do: Repo.get(User, id)
  def get_user(%User{id: id}, field), do: get_user(id, field)
  def get_user(id, field), do: get_user(id) |> Map.get(field)
end
