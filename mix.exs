defmodule SimplerSlack.Mixfile do
  use Mix.Project

  @description """
    A way to make simple slack bots that receive message, and respond to them.
  """
  def project do
    [app: :simpler_slack,
     version: "0.0.2",
     elixir: "~> 1.3",
     name: "SimplerSlack",
     description: @description,
     package: package(),
     source_url: "https://github.com/gwash3189/simplerslack",
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :crypto, :ssl, :httpoison]]
  end

  defp deps do
    [
      {:websocket_client, "~> 1.1"},
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0"},
      {:ex_doc, "~> 0.14", only: :dev},
      {:mock, "~> 0.1.1", only: :test},
      {:excoveralls, "~> 0.5", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Adam Beck"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/gwash3189/simplerslack"}
    ]
  end
end
