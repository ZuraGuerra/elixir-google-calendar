defmodule Calendar.GoogleEndpoint do
  @pool_size 3

  def start_link() do
    Calendar.PoolSupervisor.start_link(@pool_size)
  end


  def get(key) do
    key
    |> choose_worker
    |> Calendar.GoogleEndpointWorker.get(key)
  end

  def set_key(key, http_key) do
    key
    |> choose_worker
    |> Calendar.GoogleEndpointWorker.set_key(key, http_key)
  end

  def set_token(key, code) do
    key
    |> choose_worker
    |> Calendar.GoogleEndpointWorker.set_token(key, code)
  end

  def entries(key) do
    key
    |> choose_worker
    |> Calendar.GoogleEndpointWorker.entries(key)
  end

  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
end
