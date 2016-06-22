defmodule Calendar.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    processes = [
      worker(Calendar.ProcessRegistry, []),
      supervisor(Calendar.SystemSupervisor, [])
    ]
    supervise(processes, strategy: :rest_for_one)
  end
end
