# Mix.Tasks.Upload.Hotswap [![hex.pm version](https://img.shields.io/hexpm/v/mix_tasks_upload_hotswap.svg)](https://hex.pm/packages/mix_tasks_upload_hotswap)


This package provides a mix task named `mix upload.hotswap` to deploy local code changes to remote node(s) and to apply them without rebooting whole the application (the so-called `hot code swapping`).

It could be convenient when you code for IoT devices backed by [Nerves](https://www.nerves-project.org/) because it's much faster than `mix firmware && mix upload`. Although you eventually need to update the firmware if you want to persist the changes onto devices, this task could be your help in development phase because it allows you to quickly confirm if your changes work fine on the devices without waiting long time.

## Installation

Add `mix_tasks_upload_hotswap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mix_tasks_upload_hotswap, "~> 0.1.0", only: :dev}
  ]
end
```

## Prerequisites

To use this package, you need to meet the requirements below:

1. Add configurations for `mix upload.hotswap`
2. Start node(s) on your device(s) through which your code changes are deployed

### 1. Add configurations for `mix upload.hotswap`

The task `mix upload.hotswap` depends on the settings below are available:

```elixir
config :mix_tasks_upload_hotswap,
  app_name: :example,
  nodes: [:"example@nerves.local"],
  cookie: :"secret token shared between nodes"
```

All the pairs above are required to be set.

See [example/config/config.exs](https://github.com/kentaro/mix_tasks_upload_hotswap/blob/main/example/config/config.exs) for working example.

### 2. Start node(s) on your device(s) through which your code changes are deployed

Start a node which has the name and cookie set in the configuration above. The code should be like below:

```elixir
# Start a node through which local code changes are deployed
# only when the device is running in the develop environment
if Application.get_env(:example, :env) == :dev do
  System.cmd("epmd", ["-daemon"])
  Node.start(:"example@nerves.local")
  Node.set_cookie(Application.get_env(:mix_tasks_upload_hotswap, :cookie))
end
```

Notice that the node starts only when the `:env` of the application is set to `:dev`. Below is an example to configure the environment value in `config.exs`:

```elixir
config :example, env: Mix.env()
```

See [example/lib/example/application.ex](https://github.com/kentaro/mix_tasks_upload_hotswap/blob/main/example/lib/example/application.ex) and [example/config/config.exs](https://github.com/kentaro/mix_tasks_upload_hotswap/blob/main/example/config/config.exs) for working example.

## Usage

### Mix Task

Make some changes into your code and just execute the mix task as below:

```sh
$ mix upload.hotswap
```

### Illustration by `Example` App

Imagine there is an [Example](https://github.com/kentaro/mix_tasks_upload_hotswap/tree/main/example) application which has `hello` method as below:

```elixir
def hello do
  :world
end
```

You can confirm the method invoked on your device:

```sh
$ ssh nerves.local
(snip)

iex(example@nerves.local)1> Example.hello
:world
```

Suppose you made some changes like below:

```diff
diff --git a/example/lib/example.ex b/example/lib/example.ex
index ca49896..81c696a 100644
--- a/example/lib/example.ex
+++ b/example/lib/example.ex
@@ -13,6 +13,6 @@ defmodule Example do

   """
   def hello do
-    :world
+    :"new world"
   end
 end
```

You can deploy the changes to the device as below:

```sh
$ mix upload.hotswap
==> nerves
==> example

Nerves environment
  MIX_TARGET:   rpi3
  MIX_ENV:      dev

Compiling 2 files (.ex)
Generated example app
Successfully connected to example@nerves.local
Successfully deployed Elixir.Example to example@nerves.local
Successfully deployed Elixir.Example.Application to example@nerves.local
```

Now you can see the changes applied into the code on the device:

```sh
$ ssh nerves.local
(snip)

iex(example@nerves.local)1> Example.hello
:"new world"
```

It's much faster than `mix firmware && mix upload`.

### Options

#### --node

You can specify the node(s) in the cluster as below:

```sh
$ mix upload.hotswap --node example@nerves.local
```

This `--node` option can be used multiple times.

## Acknowledgement

[Using Erlang Distribution to test hardware - Embedded Elixir](https://embedded-elixir.com/post/2018-12-10-using-distribution-to-test-hardware/) inspired me how to implement this package.

## Author

[Kentaro Kuribayashi](https://kentarokuribayashi.com/)

## License

MIT
