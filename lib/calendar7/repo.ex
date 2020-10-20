defmodule Calendar7.Repo do
  use Ecto.Repo,
    otp_app: :calendar7,
    adapter: Ecto.Adapters.Postgres
end
