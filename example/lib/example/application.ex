defmodule Example.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: Example.Worker.start_link(arg)
        # {Example.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Example.Worker.start_link(arg)
      # {Example.Worker, arg},
    ]
  end

  def children(_target) do
    # Starts a node through which changes are deployed
    System.cmd("epmd", ["-daemon"])
    Node.start(Application.get_env(:recombinant, :node_name))
    Node.set_cookie(Application.get_env(:recombinant, :cookie))

    [
      # Children for all targets except host
      # Starts a worker by calling: Example.Worker.start_link(arg)
      # {Example.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:example, :target)
  end
end
