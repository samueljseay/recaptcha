defmodule Recaptcha.Mixfile do
  use Mix.Project

  def project do
    [app: :recaptcha,
     version: "2.0.0-rc.0",
     elixir: "~> 1.2",
     description: description,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    """
    A simple reCaptcha plugin for Phoenix applications.
    """
  end

  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:poison, "~> 2.1"},
      {:dialyxir, "~> 0.3", only: [:dev]}
    ]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Alekseev Mikhail"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/JustMikey/recaptcha"}]
  end
end
