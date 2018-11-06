defmodule Web.PlugRouter do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/healthcheck", do: send_resp(conn, 200, ""))
end

