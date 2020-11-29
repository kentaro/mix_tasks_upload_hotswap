# Recombinant

This package provides a mix task, `recombinant.deploy`, to deploy local changes to remote node and to apply them without rebooting whole the application.

It could be convenient when you code for a [Nerves](https://www.nerves-project.org/) device because it's much faster than `mix firmware && mix upload`. Although you eventually need to update the firmware if you want to persist the changes onto the device, this task could be your help in development phase because it allows you to quickly confirm if your changes work fine on a device without waiting long time.

## Installation

Add `recombinant` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:recombinant, git: "git@github.com:kentaro/recombinant.git"}
  ]
end
```

## Prerequisites

To use this package, you need to meet the requirements below:

1. Add configurations for Recombinant
2. Start node through which your code changes are deployed

### 1. Add configurations for Recombinant

The task `mix recombinant.deploy` depends on the settings below are available:

```elixir
config :recombinant,
  app_name: :example,
  node_name: :"example@nerves.local",
  cookie: :"secret token shared between nodes"
```

See [example/config/config.exs](./example/config/config.exs) for working example.

### 2. Start node through which your code changes are deployed

Start a node which has the name and cookie set in the configuration above. The code should be like below:

```elixir
System.cmd("epmd", ["-daemon"])
Node.start(Application.get_env(:recombinant, :node_name))
Node.set_cookie(Application.get_env(:recombinant, :cookie))
```

See [example/lib/example/application.ex](./example/lib/example/application.ex) for working example.

(**Any suggestion how to enable it only for development environment?**)

## Usage

### Mix Task

Make some changes into your code and just execute the mix task as below:

```sh
$ mix recombinant.deploy
```

### Example

`Example` module has `hello` method as below:

```elixir
def hello do
  :world
end
```

You can confirm the method invoked on the device:

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
$ mix recombinant.deploy
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

## Acknowledgement

[Using Erlang Distribution to test hardware - Embedded Elixir](https://embedded-elixir.com/post/2018-12-10-using-distribution-to-test-hardware/) inspired me how to implement this package.

## Author

[Kentaro Kuribayashi](https://kentarokuribayashi.com/)

## License

MIT
