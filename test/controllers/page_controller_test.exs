defmodule Docs.PageControllerTest do
  use Docs.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Listing documents"
  end
end
