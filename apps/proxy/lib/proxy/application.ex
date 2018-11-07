defmodule Proxy.Application do
  @moduledoc false

  use Application

  alias Proxy.Router

  @port Application.get_env(:proxy, :port)

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Router,
        options: [port: @port]
      )
    ]

    opts = [strategy: :one_for_one, name: Proxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
