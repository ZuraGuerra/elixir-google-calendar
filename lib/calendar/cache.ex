defmodule Calendar.Cache do
  use GenServer

  def start_link do
    IO.puts "Start initial cache"

    GenServer.start_link(__MODULE__, nil, name: :calendar_cache)
  end

  def server_process(calendar_username) do
    case Calendar.Server.whereis(calendar_username) do
      :undefined  ->
        GenServer.call(:calendar_cache, {:server_process, calendar_username})
      pid -> pid
    end
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, calendar_username}, _, state) do
    calendar_server_pid = case Calendar.Server.whereis(calendar_username) do
      :undefined ->
        {:ok, pid} = Calendar.ServerSupervisor.start_child(calendar_username)
        pid

      pid -> pid
    end
    {:reply, calendar_server_pid, state}
  end
end
