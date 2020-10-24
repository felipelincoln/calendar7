defmodule Calendar7.Repo.Migrations.CreateEventsUsers do
  use Ecto.Migration

  def change do
    create table(:events_users) do
      add :event_id, references(:events, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:events_users, :event_id)
    create index(:events_users, :user_id)
  end
end
