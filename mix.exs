defmodule UiKit.MixProject do
  use Mix.Project

  def project do
    [
      app: :ui_kit,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "UiKit",
      source_url: "https://github.com/example/ui_kit"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UiKit.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"}
      # Note: Heroicons is required for the icon component but cannot be a Git dependency in a Hex package.
      # The consuming application must add it to their deps:
      # {:heroicons, github: "tailwindlabs/heroicons", tag: "v2.2.0", sparse: "optimized", app: false, compile: false, depth: 1}
    ]
  end

  defp description do
    "A reusable Phoenix LiveView UI component library."
  end

  defp package do
    [
      # These are the files that will be included in the Hex package.
      # We explicitly exclude the "demo" directory.
      files: ~w(lib assets mix.exs README.md .formatter.exs LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/example/ui_kit"}
    ]
  end
end