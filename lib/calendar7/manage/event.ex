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
    |> validate_ending_date()
  end

  defp validate_ending_date(changeset) do
    starts_at = Map.get(changeset.changes, :starts_at) || Map.get(changeset.data, :starts_at)

    validate_change(changeset, :ends_at, fn _field, value ->
      case DateTime.compare(value, starts_at) do
        :gt -> []
        :lt -> [ends_at: "must be greater than starting date"]
      end
    end)
  end

end
