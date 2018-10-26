defmodule Villixir.Application do
  @moduledoc """
  Set the application.
  """

  use Application

  alias Villixir.{GameLoop}
  alias Villixir.Store.{Entity, Money}

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Entity, []),
      worker(Money, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: UaiShot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
