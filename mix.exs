defmodule Recaptcha.Mixfile do
  use Mix.Project

  def project do
    [app: :recaptcha,
     version: "1.0.2",
     elixir: "~> 1.0",
     description: description,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger, :httpotion]]
  end

  defp description do
    """
    A simple reCaptcha package for Phoenix applications.
    """
  end

  defp deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"},
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
