defmodule GoogleCalendar.Mixfile do
  use Mix.Project

  def project do
    [ app: :google_calendar,
      version: "0.0.1",
      elixir: "~> 1.1",
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger,:httpoison,:timex],
      mod: {Calendar.Application, []}
    ]
  end

  defp deps do
    [
      {:timex, "~> 2.1.6"},
      {:meck, "0.8.2", only: :test},
      {:httpoison, "~> 0.8.0"},
      {:poison, "~> 2.0"}
    ]
  end
end
