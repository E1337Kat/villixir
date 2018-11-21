defmodule Villixir.Engine do
  @moduledoc """
  The engines will contain all of the logic for the various entities
  to interact with each other and with time.
  """
  alias Villixir.Engine.Week

  @game_width 800
  @game_height 600

 @doc """
  Run game engine logic.
  For now, only run week logic
  """
  @spec run() :: :ok
  def run do
    Week.run()
    # PeopleEngine.run()
    # BuildingEngine.run()
  end

  @spec create_world([], Integer.t()) :: %{
          buildings: [],
          connections: [],
          world_height: Integer.t(),
          world_width: Integer.t()
        }
  def create_world(connections, difficulty) do
    dimensions = find_dimensions(difficulty)

    %{
      world_height: dimensions.x_dimension,
      world_width: dimensions.y_dimension,
      buildings: [],
      connections: connections
    }
  end

  defp find_dimensions(difficulty) do
    %{
      x_dimension: 100*difficulty,
      y_dimension: 100*difficulty
    }
  end
end
