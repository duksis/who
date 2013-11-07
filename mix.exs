defmodule Who.Mixfile do
  use Mix.Project

  def project do
    [ app: :who,
      version: "0.0.1",
      dynamos: [Who.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/who/ebin",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Who, [] } ]
  end

  defp deps(:prod) do
    [
      { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
      { :json, github: "cblage/elixir-json"}
    ]
  end

  defp deps(:test) do
    deps(:prod) ++
      [ {:meck, "0.8.1", github: "eproxus/meck"} ]
  end

  defp deps(_) do
    deps(:prod)
  end
end
