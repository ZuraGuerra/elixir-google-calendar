defmodule Calendar.SystemSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__,nil)
  end

  def init(_) do
    processes = [
      supervisor(Calendar.GoogleEndpoint, []),
      supervisor(Calendar.ServerSupervisor, []),
      worker(Calendar.Cache, [])
    ]
    supervise(processes, strategy: :one_for_one)
  end
end
