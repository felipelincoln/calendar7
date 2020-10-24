defmodule Calendar7.Manage do
  @moduledoc """
  The Manage context.
  """

  import Ecto.Query, warn: false
  alias Calendar7.Repo

  alias Calendar7.Manage.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  def list_events(from: date_a, to: date_b) do
    datetime_a = to_datetime(date_a)
    datetime_b = to_datetime(date_b)

    Repo.all(from e in Event, where: e.starts_at > ^datetime_a and e.starts_at < ^datetime_b)
  end

  defp to_datetime(%Date{year: year, month: month, day: day}) do
    %{DateTime.utc_now() | year: year, month: month, day: day, hour: 0, minute: 0, second: 0}
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:event_created)
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
    |> broadcast(:event_updated)
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    event
    |> Repo.delete()
    |> broadcast(:event_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  @doc """
  Include an event to user's joined_events list.

  ## Examples

      iex> join_event(user, event)
      {:ok, %User{}}

  """
  def join_event(user, event) do
    user = Repo.preload(user, :joined_events)
    events = [event | user.joined_events]

    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:joined_events, events)
    |> Repo.update()
  end

  @doc """
  Remove an event from user's joined_events list

  ## Examples

      iex> leave_event(user, event)
      {:ok, %User{}}

  """
  def leave_event(user, event) do
    user = Repo.preload(user, :joined_events)
    events = List.delete(user.joined_events, event)

    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:joined_events, events)
    |> Repo.update()
  end

  @doc """
  Verifies if user has joined an event.
  """
  def has_joined?(user, event) do
    user = Repo.preload(user, :joined_events)
    event in user.joined_events
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Calendar7.PubSub, "events")
  end

  defp broadcast({:error, _event} = changeset, _value), do: changeset
  defp broadcast({:ok, event}, value) do
    Phoenix.PubSub.broadcast(Calendar7.PubSub, "events", {value, event})
    {:ok, event}
  end
end
