defmodule Villixir.Store.Entity.Person do
  @moduledoc """
  Store state of people in town.
  """

  use Agent

  @doc """
  Start Store.
  """
  @spec start_link() :: :ok
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Return all game players.
  """
  @spec all() :: List.t()
  def all do
    Agent.get(__MODULE__, fn people ->
      people
      |> Map.to_list()
      |> Enum.map(&elem(&1, 1))
    end)
  end

  @doc """
  Get person by id.
  """
  @spec get(String.t()) :: Map.t()
  def get(person_id) do
    Agent.get(__MODULE__, &Map.get(&1, person_id, default_attrs(person_id)))
  end

  @doc """
  Update or insert a person.
  """
  @spec put(Map.t()) :: :ok
  def put(person) do
    Agent.update(__MODULE__, &Map.put(&1, person.id, person))
  end

  @doc """
  Delete person by id.
  """
  @spec kill(String.t()) :: :ok
  def kill(person_id) do
    Agent.update(__MODULE__, &Map.delete(&1, person_id))
  end

  @doc """
  Clean People.
  """
  @spec clean() :: :ok
  def clean do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  def should_die?(person_id, game_date) do

    person = Agent.get(__MODULE__, &Map.get(&1, person_id, default_attrs(person_id)))

  end

  @spec default_attrs(String.t()) :: Map.t()
  defp default_attrs(person_id) do
    %{id: person_id, nickname: person_id}
  end
end

defimpl Villixir.Store.Entity, for: Villixir.Store.Entity.Person do

  def is_person? do true end

  def get_location(person_id) do
    person = get(person_id)
  end
end
