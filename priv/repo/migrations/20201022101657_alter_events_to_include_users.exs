defmodule Calendar7.Repo.Migrations.AlterEventsToIncludeUsers do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:events, [:user_id])
  end
end
