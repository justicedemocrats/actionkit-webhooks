defmodule ActionkitWebhooks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :actionkit_webhooks,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ActionkitWebhooks, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:short_maps, "~> 0.1.2"},
      {:httpotion, "~> 3.0.3"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"},
      {:distillery, "~> 1.0.0"},
      {:actionkit, git: "https://github.com/justicedemocrats/actionkit_ex.git"},
      {:quantum, ">= 2.2.1"},
      {:flow, "~> 0.11"},
      {:airtable_config, git: "https://github.com/justicedemocrats/airtable_config.git"}
    ]
  end
end
