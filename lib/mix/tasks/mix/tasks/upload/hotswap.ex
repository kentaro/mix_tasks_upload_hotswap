defmodule Mix.Tasks.Upload.Hotswap do
  use Mix.Task

  @moduledoc File.read!("./README.md")
  @requirements ["app.config"]
  @shortdoc "Deploy local code changes to remote node(s) in hot-code-swapping manner"

  @config_key :mix_tasks_upload_hotswap

  def run(_) do
    app_name = get_config_for(:app_name)
    nodes = get_config_for(:nodes)
    cookie = get_config_for(:cookie)

    System.cmd("epmd", ["-daemon"])
    {:ok, _} = Node.start(:me@localhost)
    Node.set_cookie(cookie)

    for node <- nodes do
      handle_connect(Node.connect(node), node)
    end

    {:ok, modules} = :application.get_key(app_name, :modules)

    for module <- modules do
      for node <- nodes do
        handle_load_module(IEx.Helpers.nl([node], module), module, node)
      end
    end
  end

  defp get_config_for(key) do
    handle_config(Application.get_env(@config_key, key), key)
  end

  defp handle_config(nil, key) do
    exit("`#{@config_key}.#{key}` is required")
  end

  defp handle_config(value, _) do
    value
  end

  defp handle_connect(true, node) do
    IO.puts("Successfully connected to #{node}")
  end

  defp handle_connect(false, node) do
    exit("Failed to connect to #{node}")
  end

  defp handle_connect(:ignored, node) do
    exit("#{node} is not alive")
  end

  defp handle_load_module({:ok, [{_, :loaded, _}]}, module, node) do
    IO.puts("Successfully deployed #{module} to #{node}")
  end

  defp handle_load_module({:error, reason}, module, node) do
    IO.warn("Failed to deploy #{module} to #{node}: #{reason}")
  end
end
