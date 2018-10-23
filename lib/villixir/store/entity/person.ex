defmodule Villixir.Store.Entity.Person do
  @enforce_keys [:name, :age]
  defstruct [:name, :age, :education, :income]
end