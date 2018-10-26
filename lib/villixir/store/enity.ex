defprotocol Villixir.Store.Entity do
  @moduledoc """
  Defines the protocol for entities which should
  be implemented in the lower files.
  """

  def is_person?

  def get_location(entity)

  def put_location(entity, location)

end
