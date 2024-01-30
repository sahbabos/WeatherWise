# frozen_string_literal: true

class ForecastData
  attr_reader :date, :summary, :temp_day, :temp_night, :humidity, :pressure, :uvi, :weather

  def initialize(forecast_data)
    forecast_data = forecast_data.with_indifferent_access
    @date = forecast_data[:dt] ? Time.zone.at(forecast_data[:dt]).to_date : nil
    @summary = forecast_data[:summary]
    @temp_day = forecast_data.dig(:temp, :day) ? convert_to_celsius(forecast_data.dig(:temp, :day)) : nil
    @temp_night = forecast_data.dig(:temp, :night) ? convert_to_celsius(forecast_data.dig(:temp, :night)) : nil
    @humidity = forecast_data[:humidity]
    @pressure = forecast_data[:pressure]
    @uvi = forecast_data[:uvi]
    @weather = forecast_data[:weather].is_a?(Array) ? forecast_data[:weather].first : nil
  end

  private

  def convert_to_celsius(kelvin_temp)
    kelvin_temp ? (kelvin_temp - 273.15).round(2) : nil
  end
end
