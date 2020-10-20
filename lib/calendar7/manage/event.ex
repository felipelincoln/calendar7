defmodule Calendar7.Manage.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :description, :string
    field :ends_at, :utc_datetime
    field :starts_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:description, :starts_at, :ends_at])
    |> validate_required([:description, :starts_at, :ends_at])
  end
end
