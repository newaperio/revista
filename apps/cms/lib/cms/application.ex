defmodule CMS.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {CMS.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: CMS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
