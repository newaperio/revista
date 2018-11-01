defmodule Admin.PageControllerTest do
  use Admin.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Revista Admin"
  end
end
