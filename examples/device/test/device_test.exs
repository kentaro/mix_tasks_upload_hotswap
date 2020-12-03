defmodule DeviceTest do
  use ExUnit.Case
  doctest Device

  test "greets the world" do
    assert Device.hello() == :world
  end
end
