defmodule Villixir.Engine.EngineHelpers do
  @moduledoc """
  Defines helper functions for use in various engine components.
  """

  @doc """
  Calculates the day of the week given a date
  """
  @spec current_day_of_week(Integer.t()) :: Integer.t()
  def current_day_of_week(game_date) do
    rem(game_date, 7)
  end

end
