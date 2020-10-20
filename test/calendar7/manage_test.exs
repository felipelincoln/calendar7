defmodule Calendar7.ManageTest do
  use Calendar7.DataCase

  alias Calendar7.Manage

  describe "events" do
    alias Calendar7.Manage.Event

    @valid_attrs %{
      description: "some description",
      ends_at: ~D[2010-04-17],
      starts_at: ~D[2010-04-17]
    }
    @update_attrs %{
      description: "some updated description",
      ends_at: ~D[2011-05-18],
      starts_at: ~D[2011-05-18]
    }
    @invalid_attrs %{description: nil, ends_at: nil, starts_at: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manage.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Manage.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Manage.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Manage.create_event(@valid_attrs)
      assert event.description == "some description"
      assert event.ends_at == ~D[2010-04-17]
      assert event.starts_at == ~D[2010-04-17]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manage.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Manage.update_event(event, @update_attrs)
      assert event.description == "some updated description"
      assert event.ends_at == ~D[2011-05-18]
      assert event.starts_at == ~D[2011-05-18]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Manage.update_event(event, @invalid_attrs)
      assert event == Manage.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Manage.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Manage.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Manage.change_event(event)
    end
  end
end
