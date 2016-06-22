defmodule Calendar.GoogleEndpointWorker do
  use GenServer

  def start_link(worker_id) do
    IO.puts "Starting database worker #{worker_id}"

    GenServer.start_link(
      __MODULE__, "db_folder",
      name: via_tuple(worker_id)
    )
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  def set_key(worker_id, key, http_key) do
    GenServer.call(via_tuple(worker_id), {:set_key, key, http_key})
  end

  def set_token(worker_id, key, token) do
    GenServer.call(via_tuple(worker_id), {:set_token, key, token})
  end

  def entries(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:entries, key})
  end

  defp via_tuple(worker_id) do
    {:via, Calendar.ProcessRegistry, {:calendar_worker, worker_id}}
  end


  def init(db_folder) do
    File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  def handle_cast({:store, key, data}, db_folder) do
    file_name(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  def handle_call({:set_key, _, http_key},_,_ ) do
    {:reply, {:ok, "123"}, http_key}
  end

  def handle_call({:get, _}, _, db_folder) do
    {:reply, {:ok, "123"}, db_folder}
  end

  def handle_call({:set_token, _, token},_, _) do
    response = HTTPoison.post!("https://www.googleapis.com/oauth2/v4/token",
    {:form,
    [
      code: token,
      redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
      client_secret: "wftI5JSdALAVEaxeoFS71LvX",
      client_id: "803947449568-tksuudgsssh29i8hhqc7s7fdsa4inm5h.apps.googleusercontent.com",
      grant_type: "authorization_code"
    ]},
    %{"Content-type" => "application/x-www-form-urlencoded"})
    body = Poison.Parser.parse!(response.body)
    token = Map.get(body, "access_token")

    {:reply, {:ok, "123"}, token}
  end

  def handle_call({:entries, _},_, token) do
    x = HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
    %{
      "Authorization" => "Bearer #{token}",
    })

    {:reply, {:ok, x}, token}
  end

  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"
end
