defmodule Calendar.Server do
  use GenServer

  def start_link(name) do
    IO.puts "Starting calendar server for #{name}"
    GenServer.start_link(Calendar.Server, name, name: via_tuple(name))
  end

  def login_url(calendar_server) do
    GenServer.call(calendar_server, {:login_url})
  end

  def set_key(calendar_server, key) do
    GenServer.call(calendar_server, {:set_key, key})
  end

  def set_token(calendar_server, token) do
    GenServer.call(calendar_server, {:set_token, token})
  end

  def entries(calendar_server) do
    GenServer.call(calendar_server, {:entries})
  end

  def get_events(calendar) do
    GenServer.call(calendar, {:get_events})
  end

  def get_event(calendar, event_id) do
    GenServer.call(calendar, {:get_event, event_id})
  end

  def create_event(calendar, date, time, description) do
    GenServer.call(calendar, {:create_event, date, time, description})
  end

  def delete_event(calendar, event_id) do
    GenServer.call(calendar, {:delete_event, event_id})
  end

  def whereis(name) do
    Calendar.ProcessRegistry.whereis_name({:calendar_server, name})
  end

  def via_tuple(name) do
    {:via, Calendar.ProcessRegistry, {:calendar_server, name}}
  end


  def init(name) do
    {:ok, {name, Calendar.GoogleEndpoint.get(name) || []}}
  end


  def handle_call({:login_url}, _, {name, calendar_list}) do
    {:reply,
    "https://accounts.google.com/o/oauth2/v2/auth?scope=email+profile+https://www.googleapis.com/auth/calendar&response_type=code&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&client_id=803947449568-tksuudgsssh29i8hhqc7s7fdsa4inm5h.apps.googleusercontent.com&from_login=1&as=-2a7c1353bdfaccc8&authuser=0",
    {name, calendar_list}}
  end

  def handle_call({:set_token, token}, _, {name, calendar_list}) do
    {:reply,
    Calendar.GoogleEndpoint.set_token(name, token),
    {name, calendar_list}}
  end

  def handle_call({:set_key, key}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.set_key(name, key),{name, calendar_list}}
  end

  def handle_call({:entries}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.entries(name),{name, calendar_list}}
  end

  def handle_call({:get_events}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.get_events(name), {name, calendar_list}}
  end

  def handle_call({:get_event, event_id}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.get_event(name, event_id), {name, calendar_list}}
  end

  def handle_call({:create_event, date, time, description}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.create_event(name, date, time, description), {name, calendar_list}}
  end

  def handle_call({:delete_event, event_id}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.delete_event(name, event_id), {name, calendar_list}}
  end

  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}
end
