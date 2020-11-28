defmodule RecombinantTest do
  use ExUnit.Case
  doctest Recombinant

  test "greets the world" do
    assert Recombinant.hello() == :world
  end
end
