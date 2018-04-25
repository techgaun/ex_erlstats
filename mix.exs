defmodule ExErlstats.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_erlstats,
     version: "0.1.6",
     name: "ExErlstats",
     description: "A simple module to get erlang VM stats",
     source_url: "https://github.com/techgaun/ex_erlstats",
     homepage_url: "https://github.com/techgaun",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [extras: ["README.md"]],
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.13", only: :dev},
      {:earmark, "~> 1.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: [
        "Samar Acharya"
      ],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/techgaun/ex_erlstats", "Website" => "http://samar.techgaun.com"},
      files: ~w(config lib mix.exs README.md LICENSE)
    ]
  end
end
