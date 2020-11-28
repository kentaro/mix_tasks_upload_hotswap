# Recombinant

This package provides a mix task, `recombinant.deploy`, to deploy local changes of modules to remote nodes. It could be convenient when you code for a Nerves device; you can confirm if your changes work fine or not without `mix upload`.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `recombinant` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:recombinant, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/recombinant](https://hexdocs.pm/recombinant).
