defmodule Proxy.Router do
  def init(options), do: options

  def call(conn, _opts) do
    cond do
      conn.request_path =~ ~r{/admin} ->
        Admin.Endpoint.call(conn, [])

      conn.request_path =~ ~r{/twitter} ->
        Twitter.Endpoint.call(conn, [])

      true ->
        Web.Endpoint.call(conn, [])
    end
  end
end
