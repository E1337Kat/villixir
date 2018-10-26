defmodule Villixir.Engine.PeopleEngine do
  @moduledoc """
  This engine piece manages the people in the town.
  Each person has a lifespan that is ran, and then
  if still alive, daily tasks are decided based on the
  person's schedule. Each person has a set number of days
  which they work, and when on a work day, the WeekSchedule
  is ran, otherwise the WeekendSchedule is ran.
  """

  alias Villixir.Engine.{WorkTimeSchedule, FreeTimeSchedule, EngineHelpers}
  alias Villixir.Store.Entity.Person
  alias Villixir.Store.Entity.Person.{Resident, Visitor}

  @doc """
  Run game person logic.
  """
  @spec run(Integer.t()) :: :ok
  def run(game_date) do
    day_of_week = EngineHelpers.current_day_of_week(game_date)
    Person.all()
    |> kill_old_people(game_date)
    |> bear_new_children()
    |> Enum.map(&process_person(&1, day_of_week))
  end

  @spec is_resident?() :: Boolean.t()
  defp is_resident?() do
    true
  end

  @spec process_person(Map.t(), Integer.t()) :: Map.t()
  defp process_person(people, day_of_week) do
    residents = Enum.map(people, is_resident?())
    visitors = Enum.reject(people, fn -> Enum.member?(residents, people.any?()) end)

    workers = working_today(residents, day_of_week)
    |> process_workers()

    Enum.concat(visitors, Enum.reject(residents, fn x -> Enum.member?(workers, x) end))
    |> process_non_workers()

  end

  @doc """
  Kill off all the old people that are supposed to die.
  Ultimately, random deaths should happen based on town
  safety in various areas and health.
  """
  @spec kill_old_people(Map.t(), Integer.t()) :: Map.t()
  defp kill_old_people(people, game_date) do
    kill_list = Enum.map(people, people.each() |> Person.should_die?(game_date))

    kill_list.each()
    |> people.kill()
  end

  @doc """
  Create new children. Ultimately, the production
  rate should be based on population demographics.
  """
  @spec bear_new_children(Map.t()) :: Map.t()
  defp bear_new_children(people) do
    # Determine amount of children to be born
    # For now, 1 new child should be born a day

    people.put(generate_new_resident())
  end

  @doc """
  Returns a map of people which do work on the given day.
  """
  defp working_today(people, day_of_week) do
    people
    |> Enum.map(fn x -> Enum.member?(x.work_days, day_of_week) end)
  end

  defp process_workers(people) do
    WorkTimeSchedule.run(people)
  end

  defp process_non_workers(people) do
    FreeTimeSchedule.run(people)
  end

  defp generate_new_resident do
    %{name: "eh", age: 1, work: 63 }
  end

end
