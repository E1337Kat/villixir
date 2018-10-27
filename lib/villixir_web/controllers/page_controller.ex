defmodule VillixirWeb.PageController do
  use VillixirWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
