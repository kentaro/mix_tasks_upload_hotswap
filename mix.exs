defmodule Mix.Tasks.Upload.Hotswap.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_tasks_upload_hotswap,
      version: "0.1.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      name: "mix upload.hotswap",
      source_url: "https://github.com/kentaro/mix_tasks_upload_hotswap",
      homepage_url: "https://github.com/kentaro/mix_tasks_upload_hotswap",
      description: description(),
      deps: deps(),
      xref: [exclude: IEx.Helpers],
      package: package(),
      docs: docs()
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
      {:ex_doc, "~> 0.23", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Deploy local code changes to the remote node(s) in a hot-code-swapping manner."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kentaro/mix_tasks_upload_hotswap"},
      files: [
        # These are the default files
        "lib",
        "LICENSE",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp docs do
    [
      main: "Mix.Tasks.Upload.Hotswap"
    ]
  end
end
