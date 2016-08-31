defmodule Recaptcha.Mixfile do
  use Mix.Project

  def project do
    [app: :recaptcha,
     version: "2.0.0",
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
    A simple reCaptcha package for Elixir applications, provides verification
    and templates for rendering forms with the reCaptcha widget
    """
  end

  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0"},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Samuel Seay"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/samueljseay/recaptcha"}]
  end
end
