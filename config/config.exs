# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :job_bot,
  namespace: JobBot,
  ecto_repos: [JobBot.Repo]

# Configures the endpoint
config :job_bot, JobBotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h7swLtSL9xEbyJfXy6Isgr9w3OKeZJIfSkm9G6x0XuvFKHXpCPsgvM99zWPlg5La",
  render_errors: [view: JobBotWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JobBot.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :arc,
  storage: Arc.Storage.Local,
  storage_dir: "uploads/tmp/resumes"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
