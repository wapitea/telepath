defmodule Telepath.MixProject do
  use Mix.Project

  def project do
    [
      app: :telepath,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Telepath",
      description: "Telepath is, in essence, xPath/JsonPath for elixir structs.",
      source_url: "https://github.com/wapitea/telepath",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]                       
  end

  defp package do
    [
      maintainers: ["Alexandre Lepretre", "Antoine Pecatikov"],
      licenses: ["GNU GPLv3"],
      links: %{"Github" => "https://github.com/wapitea/telepath"},
      name: "telepath"
    ]
  end
end
