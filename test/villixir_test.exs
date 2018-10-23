defmodule VillixirTest do
  use ExUnit.Case
  doctest Villixir

  test "greets the world" do
    assert Villixir.hello() == :world
  end
end
