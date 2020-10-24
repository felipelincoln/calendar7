defmodule Calendar7.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias Calendar7.Manage.Event

  schema "users" do
    pow_user_fields()

    timestamps()

    has_many :events, Event
    many_to_many :joined_events, Event, join_through: "events_users", on_replace: :delete
  end
end
