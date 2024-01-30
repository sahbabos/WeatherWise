# frozen_string_literal: true

# app/views/weather/show.json.jbuilder

if @error
  json.error @error
else
  json.current_weather @current_weather do |weather|
    json.extract! weather, :temperature, :weather_condition, :humidity, :wind_speed
  end
  json.from_cache @from_cache
end
