defmodule Calendar.ServerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: :calendar_server_supervisor)
  end

  def start_child(calendar_username) do
    Supervisor.start_child(:calendar_server_supervisor, [calendar_username])
  end

  def init(_) do
    supervise([worker(Calendar.Server, [])], strategy: :simple_one_for_one)
  end
end
