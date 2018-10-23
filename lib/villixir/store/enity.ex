defmodule Villixir.Store.Entity do
  @enforce_keys [:type]
  defstruct [:id, :type]
end