defmodule Admin.PostControllerTest do
  use Admin.ConnCase

  test "GET /posts", %{conn: conn} do
    Auth.register(%{email: "alice@example.com", password: "password"})

    conn =
      conn
      |> post("/sessions", %{session: %{email: "alice@example.com", password: "password"}})
      |> get("/posts")

    assert conn.status == 200
    assert conn.resp_body =~ "Posts"
  end
end
