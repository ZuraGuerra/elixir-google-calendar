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

  def get_events(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get_events, key})
  end

  def get_event(worker_id, key, event_id) do
    GenServer.call(via_tuple(worker_id), {:get_event, key, event_id})
  end

  def create_event(worker_id, key, date, time, description) do
    GenServer.call(via_tuple(worker_id), {:create_event, key, date, time, description})
  end

  def delete_event(worker_id, key, event_id) do
    GenServer.call(via_tuple(worker_id), {:delete_event, key, event_id})
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

    {:reply, {:ok, :token_set}, token}
  end

  def handle_call({:entries, _},_, token) do
    response = HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
    %{
      "Authorization" => "Bearer #{token}",
    })

    {:reply, {:ok, response}, token}
  end

  def handle_call({:get_events, _},_, token) do
    response = HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
    %{
      "Authorization" => "Bearer #{token}",
    })

    body = Poison.Parser.parse!(response.body)
    [first_calendar|rest] = Map.get(body, "items")
    cal_id = Map.get(first_calendar, "id")
    response = HTTPoison.get!("https://www.googleapis.com/calendar/v3/calendars/#{cal_id}/events",
    %{
      "Authorization" => "Bearer #{token}",
    })
    body = Poison.Parser.parse!(response.body)
    items = Map.get(body, "items")
    result = Enum.map(items, fn(x) -> %{
      "id" => Map.get(x, "id"),
      "start" => Map.get(x, "start"),
      "summary" => Map.get(x, "summary")} end)


    {:reply, {:ok, result}, token}
  end

  def handle_call({:get_event,_, event_id},_, token) do
    response = HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
    %{
      "Authorization" => "Bearer #{token}",
    })

    body = Poison.Parser.parse!(response.body)
    [first_calendar|rest] = Map.get(body, "items")
    cal_id = Map.get(first_calendar, "id")

    #cal_id rsqolj380kvf1r81ae2me86odc@group.calendar.google.com
    #token = "ya29.Ci8JA4jPV23ZBZ5UuAux7W8AkQo4nIhE9vx5cCdrKvk2VkfdKBq89rSiyWP1YsT1-Q"
    IO.puts "cal_id: #{cal_id}, event_id#{event_id}"
    x = HTTPoison.get!("https://www.googleapis.com/calendar/v3/calendars/#{cal_id}/events/#{event_id}",
    %{
      "Authorization" => "Bearer #{token}",
    })
    body1 = Poison.Parser.parse!(x.body)


    {:reply, {:ok, body1}, token}
  end

  def handle_call({:create_event,_, date, time, description},_, token) do
    #cal_id = "rsqolj380kvf1r81ae2me86odc@group.calendar.google.com"
    #token = "ya29.Ci8JA4jPV23ZBZ5UuAux7W8AkQo4nIhE9vx5cCdrKvk2VkfdKBq89rSiyWP1YsT1-Q"
    response = HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
    %{
      "Authorization" => "Bearer #{token}",
    })

    body = Poison.Parser.parse!(response.body)
    [first_calendar|rest] = Map.get(body, "items")
    cal_id = Map.get(first_calendar, "id")

    {:ok, date_time} = Timex.datetime({date, time}) |> Timex.format("{ISO}")

    response = HTTPoison.post!("https://www.googleapis.com/calendar/v3/calendars/#{cal_id}/events/?alt=json",
    ~s({"end": {"dateTime": "#{date_time}" },"start": {"dateTime": "#{date_time}" }, "summary": "#{description}"}),
    %{
      "Authorization" => "Bearer #{token}",
      "content-type" => "application/json"
    })
    body = Poison.Parser.parse!(response.body)


    {:reply, {:ok, body}, token}
  end

  def handle_call({:delete_event,_,  event_id},_, token) do
    response = HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
    %{
      "Authorization" => "Bearer #{token}",
    })

    body = Poison.Parser.parse!(response.body)
    [first_calendar|rest] = Map.get(body, "items")
    cal_id = Map.get(first_calendar, "id")

    #cal_id rsqolj380kvf1r81ae2me86odc@group.calendar.google.com
    #token = "ya29.Ci8JA4jPV23ZBZ5UuAux7W8AkQo4nIhE9vx5cCdrKvk2VkfdKBq89rSiyWP1YsT1-Q"
    x = HTTPoison.delete!("https://www.googleapis.com/calendar/v3/calendars/#{cal_id}/events/#{event_id}",
    %{
      "Authorization" => "Bearer #{token}",
    })


    {:reply, {:ok, :fine}, token}
  end



  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"
end
