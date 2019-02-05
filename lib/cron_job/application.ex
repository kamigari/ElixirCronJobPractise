defmodule CronJob.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      CronJob
    ]

    opts = [strategy: :one_for_one, name: CronJob.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
