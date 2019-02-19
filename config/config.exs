# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :actionkit_webhooks, ActionkitWebhooks.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OQfJkeLiLjQUsWnGdBY+5gPG+PnpYMdOfmFi/BPs9/RByw68PWyQWuLx2eihGvfX",
  render_errors: [view: ActionkitWebhooks.ErrorView, accepts: ~w(json)],
  pubsub: [name: ActionkitWebhooks.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :actionkit_webhooks, ActionkitWebhooks.Scheduler,
  jobs: [
    {"*/5 * * * *", {ActionkitWebhooks.AirtableCache, :update, []}},
    {"*/1 * * * *", {ActionkitWebhooks.ExecuteHooks, :execute_all, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
