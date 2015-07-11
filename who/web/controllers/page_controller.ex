defmodule Who.PageController do
  use Who.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
