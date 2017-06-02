defmodule Recaptcha.Mixfile do
  use Mix.Project

  def project do
    [
      app: :recaptcha,
      version: "2.1.1",
      elixir: "~> 1.2",
      description: description(),
      deps: deps(),
      package: package(),

      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      # Test coverage:
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ],
   ]
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
      {:httpoison, "~> 0.11.0"},
      {:poison, "~> 1.5 or ~> 2.0 or ~> 3.0"},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.5", only: :test},
    ]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Samuel Seay", "Nikita Sobolev", "Michael JustMikey"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/samueljseay/recaptcha"}]
  end
end
