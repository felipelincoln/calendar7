defmodule Calendar7.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias Calendar7.Manage.Event

  schema "users" do
    pow_user_fields()

    timestamps()

    has_many :events, Event
  end
end
