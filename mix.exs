defmodule Telepath.MixProject do
  use Mix.Project

  @source_url "https://github.com/wapitea/telepath"

  def project do
    [
      app: :telepath,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Telepath",
      description: "Telepath is, in essence, xPath/JsonPath for elixir structs.",
      source_url: @source_url,
      docs: docs()
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

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      maintainers: ["Alexandre Lepretre", "Antoine Pecatikov"],
      licenses: ["GNU GPLv3"],
      links: %{"Github" => @source_url},
      name: "telepath"
    ]
  end
end
