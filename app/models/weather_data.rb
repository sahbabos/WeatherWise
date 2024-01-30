# frozen_string_literal: true

class WeatherData
  def initialize(data)
    @data = data.with_indifferent_access
  end

  def formatted_time
    format_unix_time(data[:dt])
  end

  def sunrise
    format_unix_time(data[:sunrise])
  end

  def sunset
    format_unix_time(data[:sunset])
  end

  def temperature
    convert_to_celsius(data[:temp])
  end

  def feels_like
    convert_to_celsius(data[:feels_like])
  end

  def pressure
    "#{data[:pressure]} hPa" if data[:pressure]
  end

  def humidity
    "#{data[:humidity]}%" if data[:humidity]
  end

  def uvi
    data[:uvi]
  end

  def clouds
    "#{data[:clouds]}%" if data[:clouds]
  end

  def visibility
    "#{data[:visibility] / 1000.0} km" if data[:visibility]
  end

  def icon
    current_weather[:icon] if current_weather
  end

  def description
    current_weather[:description] if current_weather
  end

  def main
    current_weather[:main] if current_weather
  end

  private

  attr_reader :data

  def format_unix_time(timestamp)
    Time.zone.at(timestamp).getutc.to_s if timestamp
  end

  def convert_to_celsius(kelvin_temp)
    (kelvin_temp - 273.15).round(2) if kelvin_temp
  end

  def current_weather
    @current_weather ||= data[:weather].is_a?(Array) ? data[:weather].first : nil
  end
end
