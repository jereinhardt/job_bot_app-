defmodule JobBot.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(JobBot.Repo, []),
      supervisor(JobBotWeb.Endpoint, []),
      supervisor(JobBot.CrawlerSupervisor, []),
      worker(JobBot.WorkerRegistry, [])
    ]

    opts = [strategy: :one_for_one, name: JobBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    JobBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
