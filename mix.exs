defmodule Recaptcha.Mixfile do
  use Mix.Project

  def project do
    [app: :recaptcha,
     version: "1.1.0",
     elixir: "~> 1.0",
     description: description,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    """
    A simple reCaptcha package for Phoenix applications.
    """
  end

  defp deps do
    [
      {:httpoison, "~> 0.7.2"},
      {:poison, "~> 1.5"}
    ]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Alekseev Mikhail"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/JustMikey/recaptcha"}]
  end
end
