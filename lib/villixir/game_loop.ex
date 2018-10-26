defmodule Villixir.GameLoop do
  @moduledoc """
  Gameloop. Executes all game engines.
  """

  use GenServer

  alias Villixir.Engine

  @worker_interval 20

  @doc """
  Start the gameloop
  """
  @spec start_link(State.t()) :: :ok
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Init Game Loop scheduler.
  """
  @spec init(State.t()) :: {:ok, State.t()}
  def init(state) do
    :timer.send_interval(@worker_interval, :work)
    {:ok, state}
  end

  @doc """
  Executes all game engines.
  """
  @spec handle_info(:work, State.t()) :: {:noreply, State.t()}
  def handle_info(:work, state) do
    Engine.run()
    {:noreply, state}
  end
end
