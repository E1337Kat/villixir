# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :villixir,
  ecto_repos: [Villixir.Repo]

# Configures the endpoint
config :villixir, VillixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qm9xrgFjmr1UzMN8y7WBkDgHzmLa02/WVd3I1KHboy8k6kFdUrkN2An3ONV1eC+w",
  render_errors: [view: VillixirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Villixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
