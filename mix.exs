defmodule Mix.Tasks.Upload.Hotswap.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_tasks_upload_hotswap,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      xref: [exclude: IEx.Helpers],

      # Docs
      name: "mix upload.hotswap",
      source_url: "https://github.com/kentaro/mix_tasks_upload_hotswap",
      homepage_url: "https://github.com/kentaro/mix_tasks_upload_hotswap",
      docs: [
        main: "Mix.Tasks.Upload.Hotswap",
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
    ]
  end
end
