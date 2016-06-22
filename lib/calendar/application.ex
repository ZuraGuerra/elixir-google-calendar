defmodule Calendar.Application do
  use Application

  def start(_, _) do
    Calendar.Supervisor.start_link
  end
end
