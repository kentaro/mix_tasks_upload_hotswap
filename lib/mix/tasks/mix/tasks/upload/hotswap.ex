defmodule Mix.Tasks.Upload.Hotswap do
  use Mix.Task

  @moduledoc File.read!("./README.md")
  @requirements ["app.config"]
  @shortdoc "Deploy modules to remote nodes."

  def run(_) do
    app_name = Application.get_env(:mix_tasks_upload_hotswap, :app_name)
    node_name = Application.get_env(:mix_tasks_upload_hotswap, :node_name)
    cookie = Application.get_env(:mix_tasks_upload_hotswap, :cookie)

    System.cmd("epmd", ["-daemon"])
    {:ok, _} = Node.start(:"me@localhost")
    Node.set_cookie(cookie)
    handle_connect(Node.connect(node_name), node_name)

    {:ok, modules} = :application.get_key(app_name, :modules)
    for module <- modules do
      handle_load_module(IEx.Helpers.nl([node_name], module), module, node_name)
    end
  end

  defp handle_connect(true, node_name) do
    IO.puts("Successfully connected to #{node_name}")
  end

  defp handle_connect(false, node_name) do
    exit("Failed to connect to #{node_name}")
  end

  defp handle_connect(:ignored, node_name) do
    exit("#{node_name} is not alive")
  end

  defp handle_load_module({:ok, [{_, :loaded, _}]}, module, node_name) do
    IO.puts("Successfully deployed #{module} to #{node_name}")
  end

  defp handle_load_module({:error, reason}, module, node_name) do
    IO.warn("Failed to deploy #{module} to #{node_name}: #{reason}")
  end
end
