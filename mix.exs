defmodule Haystack.MixProject do
  use Mix.Project

  def project do
    [
      app: :haystack,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Haystack]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:poison, "~> 3.1"}
    ]
  end
end
