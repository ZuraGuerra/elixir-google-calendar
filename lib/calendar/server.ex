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
    IO.puts "THe name is: #{name}"
    IO.puts "The key is #{key}"
    {:reply,Calendar.GoogleEndpoint.set_key(name, key),{name, calendar_list}}
  end

  def handle_call({:entries}, _, {name, calendar_list}) do
    {:reply,Calendar.GoogleEndpoint.entries(name),{name, calendar_list}}
  end

  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}
end
