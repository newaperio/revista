defmodule Twitter.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      Twitter.Endpoint,
      worker(Twitter.Collector, [])
    ]

    opts = [strategy: :one_for_one, name: Twitter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Twitter.Endpoint.config_change(changed, removed)
    :ok
  end
end
