defmodule Proxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :proxy,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Proxy.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:admin, in_umbrella: true},
      {:twitter, in_umbrella: true},
      {:web, in_umbrella: true}
    ]
  end
end
