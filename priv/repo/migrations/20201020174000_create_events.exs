defmodule Calendar7.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :description, :string
      add :starts_at, :date
      add :ends_at, :date

      timestamps()
    end
  end
end
