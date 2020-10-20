defmodule Calendar7.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :description, :string
      add :starts_at, :utc_datetime
      add :ends_at, :utc_datetime

      timestamps()
    end

  end
end
