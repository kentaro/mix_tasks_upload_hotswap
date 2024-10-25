defmodule Mix.Tasks.Upload.Hotswap do
  @moduledoc File.read!("./README.md")

  use Mix.Task

  @requirements ["app.config"]
  @config_key :mix_tasks_upload_hotswap

  @shortdoc "Deploy local code changes to the remote node(s) in a hot-code-swapping manner"
  def run(args) do
    opts = parse_args(args)

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

    target_nodes =
      if is_nil(opts[:node]) do
        nodes
      else
        targets =
          Keyword.get_values(opts, :node)
          |> Enum.map(&:"#{&1}")

        Enum.filter(nodes, &(&1 in targets))
      end

    # upload the modules twice to ensure the codes on the remote devices fully replaced
    # https://erlang.org/doc/reference_manual/code_loading.html#code-replacement
    for _ <- 0..1 do
      for module <- modules do
        for node <- target_nodes do
          handle_load_module(IEx.Helpers.nl([node], module), module, node)
        end
      end
    end
  end

  @spec parse_args(args :: [String.t()]) :: OptionParser.parsed()
  def parse_args(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        strict: [
          node: :keep
        ]
      )

    opts
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
    Mix.shell().info("Successfully deployed #{module} to #{node}")
  end

  defp handle_load_module({:error, reason}, module, node) do
    Mix.shell().error("Failed to deploy #{module} to #{node}: #{reason}")
  end
end
