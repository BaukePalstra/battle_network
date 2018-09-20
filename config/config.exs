# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :battle_network, BattleNetworkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oNajM7l6ZMaWz8qoqygESW17/RSs6F0iycImpEjffEY17SZ/YrO1BOdZxYewB1DN",
  render_errors: [view: BattleNetworkWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BattleNetwork.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
