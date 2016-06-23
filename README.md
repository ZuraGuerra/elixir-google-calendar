# GoogleCalendar

# Intro
Based on https://github.com/sasa1977/elixir-in-action/tree/master/code_samples/ch11/todo_app
*TODO: Add description*
*TODO: Add unit tests*
*TODO: token can be set, not only get via code in set_token*
*TODO: Better caching/process strategy*
*TODO: показываем форму авторизации, после интерфейс должен состоять из окна ответов от сервера и поля для ввода команд?*
*TODO: interface for dates create_event 31-12-2016 23:59 "Налить шампанского и наложить салатиков"*

## Usage
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
