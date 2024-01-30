# frozen_string_literal: true

# app/views/weather/index.json.jbuilder

if @error
  json.error @error
else
  json.eight_day_forecast @eight_day_forecast.each do |day_forecast|
    json.set! day_forecast[:date] do # Adapt the key for date
      json.extract! day_forecast, :temperature, :weather_condition, :humidity, :wind_speed
    end
  end
  json.from_cache @from_cache
end
