# GoogleCalendar

Based on https://github.com/sasa1977/elixir-in-action/tree/master/code_samples/ch11/todo_app
**TODO: Add description**
**TODO: Add unit tests**
**TODO: token can be set, not only get via code in set_token**
**TODO: Better caching/process strategy**
**TODO: показываем форму авторизации, после интерфейс должен состоять из окна ответов от сервера и поля для ввода команд?**
**TODO: interface for dates create_event 31-12-2016 23:59 "Налить шампанского и наложить салатиков"**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add google_calendar to your list of dependencies in `mix.exs`:

        def deps do
          [{:google_calendar, "~> 0.0.1"}]
        end

  2. Ensure google_calendar is started before your application:

        def application do
          [applications: [:google_calendar]]
        end

calendar = Calendar.Cache.server_process("my")
Calendar.Server.login_url(calendar) # get code, which should be used in set token
Calendar.Server.set_token(calendar, "4/j_8N9BB0k0lT165uADWp0gJyL4oErLKc6-z5ep226uY")
Calendar.Server.get_events(calendar)
event_id = "id4gr2u29nqesn6b9i8ffv4hk8"
Calendar.Server.get_event(calendar, event_id)
date = {2016,7,7}
time = {3,4,5}
Calendar.Server.create_event(calendar, date, time, "description")
Calendar.Server.delete_event(calendar, event_id)

Calendar.Server.set_key(bobs_list, "4/-ooAm0v5dyuJ12dbnwnShXewx_XbiyCk0SKIQ62wMcw")

x = HTTPoison.get!("https://www.googleapis.com/calendar/v3/calendars/#{calendar_id}/events",
%{
  "Authorization" => "Bearer #{token}",
})


get_url
set_key
entries with token!

Calendar.Cache.server_process("Bob's list")
Todo.Server.add_entry(
  bobs_list,
  %{date: {2013, 12, 19}, title: "Dentist"}
)

curl -d "client_id=803947449568-tksuudgsssh29i8hhqc7s7fdsa4inm5h.apps.googleusercontent.com" -d "client_secret=wftI5JSdALAVEaxeoFS71LvX" -d "code=4/uKAZKvyRHGt0Ni-cos-Av3YN2-XSx3mFIg-40ISbERk" -d "grant_type=authorization_code" -d "redirect_uri=urn:ietf:wg:oauth:2.0:oob" https://www.googleapis.com/oauth2/v4/token


curl -H "Authorization: Bearer ya29.Ci8IA2rXmQUlY8hR_MXHz1TKIjZ_rAGIzZfAWlQtvISdDVLIL7IBEo2cbASr8VsoEg" "https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4"


HTTPoison.get!("https://www.googleapis.com/calendar/v3/users/me/calendarList?maxResults=1&minAccessRole=owner&showDeleted=false&showHidden=false&key=AIzaSyBHnDD0R92S2dFsXagjNEEY7SVcdeCM4v4",
%{
  "Authorization" => "Bearer ya29.Ci8IA2rXmQUlY8hR_MXHz1TKIjZ_rAGIzZfAWlQtvISdDVLIL7IBEo2cbASr8VsoEg",
})


[%{"created" => "2013-05-15T13:19:07.000Z",
   "creator" => %{"displayName" => "Александр Костриков",
     "email" => "alexandr.kostrikov@gmail.com"},
   "end" => %{"dateTime" => "2013-05-22T22:00:00+04:00"},
   "etag" => "\"2738266048322000\"",
   "htmlLink" => "https://www.google.com/calendar/event?eid=OXRnNnRvNDJwbzR2MmFzMzl2YzUwZnU3MDQgcnNxb2xqMzgwa3ZmMXI4MWFlMm1lODZvZGNAZw",
   "iCalUID" => "9tg6to42po4v2as39vc50fu704@google.com",
   "id" => "9tg6to42po4v2as39vc50fu704", "kind" => "calendar#event",
   "organizer" => %{"displayName" => "Games",
     "email" => "rsqolj380kvf1r81ae2me86odc@group.calendar.google.com",
     "self" => true}, "reminders" => %{"useDefault" => true}, "sequence" => 2,
   "start" => %{"dateTime" => "2013-05-22T21:00:00+04:00"},
   "status" => "confirmed",
   "summary" => "eve online поставить #games ",
   "updated" => "2013-05-21T10:43:44.161Z"}]


date, time
{{1970,1,1}, {0,0,0}}
