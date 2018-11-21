defmodule VillixirTest do
  use ExUnit.Case
  doctest Villixir

  test "creates the world" do
    world = %{
      world_width: 100,
      world_height: 100,
      buildings: [],
      connections: [{"Javierville", "south"}, {"Capetown", "west"}]
    }

    connections = [
      {"Javierville", "south"},
      {"Capetown", "west"}
    ]
    difficulty = 1

    assert Villixir.Engine.create_world(connections, difficulty) == world
  end

end
