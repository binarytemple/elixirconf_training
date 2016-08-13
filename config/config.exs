# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :docs,
  ecto_repos: [Docs.Repo]

# Configures the endpoint
config :docs, Docs.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "sraoBTzJymreHSNmTZxzqKEi6i0q35lYTyl9+16TwLea52ehsjniD1d3xOa6rmxA",
  render_errors: [default_format: "html"],
  pubsub: [name: Docs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
