# GoogleCalendar

**TODO: Add description**

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

bobs_list = Calendar.Cache.server_process("Bob's list")
Calendar.Server.login_url(bobs_list)
Calendar.Server.set_token(bobs_list, "4/QcjUJeB0sYguOdczt3I3_hzo9nAJCU1Wa121AryEg50")
Calendar.Server.entries(bobs_list)


Calendar.Server.set_key(bobs_list, "4/0kdU7CXyJDcubCl9uoJhQP08T0EAC2M9dpwVcD-_jGA")


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
