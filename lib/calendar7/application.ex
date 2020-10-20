defmodule Calendar7.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Calendar7.Repo,
      # Start the Telemetry supervisor
      Calendar7Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Calendar7.PubSub},
      # Start the Endpoint (http/https)
      Calendar7Web.Endpoint
      # Start a worker by calling: Calendar7.Worker.start_link(arg)
      # {Calendar7.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Calendar7.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Calendar7Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
