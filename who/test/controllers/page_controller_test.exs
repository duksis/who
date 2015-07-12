defmodule Who.PageControllerTest do
  use Who.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 302) =~ "You must be logged in"
  end
end
