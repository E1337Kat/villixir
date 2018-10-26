defmodule Villixir.Engine do
  @moduledoc """
  The engines will contain all of the logic for the various entities
  to interact with each other and with time.
  """
  alias Villixir.Engine.{PeopleEngine, Week, MoneyEngine}

  @game_width 800
  @game_height 600

 @doc """
  Run game engine logic.
  """
  @spec run() :: :ok
  def run do
    Week.run()
    |> PeopleEngine.run()

    MoneyEngine.run()
  end
end
