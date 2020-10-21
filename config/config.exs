# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :calendar7,
  ecto_repos: [Calendar7.Repo]

# Configures authentication
config :calendar7, :pow,
  user: Calendar7.Users.User,
  repo: Calendar7.Repo

# Configures the endpoint
config :calendar7, Calendar7Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TNoePiFMgi+94lPjERmWhBpz+yZ4mSjswSnXTP3arLury88zEdTFWiCDvpLv90J6",
  render_errors: [view: Calendar7Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Calendar7.PubSub,
  live_view: [signing_salt: "7MAm2ER1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
