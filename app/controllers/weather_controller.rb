# frozen_string_literal: true

require 'net/http'
require 'json'

class WeatherController < ApplicationController
  before_action :set_api_key

  def show
    zip_code = params[:zip_code]
    @from_cache = false
    @error = nil

    # Check cache
    cached_data = Rails.cache.read(zip_code)

    if cached_data
      @weather_data = cached_data
      @from_cache = true
    else
      # Call the API
      location_info = get_location_info(zip_code)

      if location_info && location_info['lat'] && location_info['lon']
        @current_weather = get_weather_info(location_info['lat'], location_info['lon'], 'current')
        @weather_data = WeatherData.new(@current_weather) if @current_weather
        # Cache the result
        Rails.cache.write(zip_code, @weather_data, expires_in: 30.minutes)
      else
        @error = 'Unable to retrieve weather data.'
      end
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def index
    zip_code = params[:zip_code]
    @from_cache = false
    @error = nil

    # Construct a unique cache key for the 8-day forecast
    cache_key = "#{zip_code}_8_day_forecast"
    # Check cache
    cached_data = Rails.cache.read(cache_key)

    if cached_data
      @eight_day_forecast = cached_data.map { |day_data| ForecastData.new(day_data) }
      @from_cache = true
    else
      # Call the API
      location_info = get_location_info(zip_code)

      if location_info && location_info['lat'] && location_info['lon']
        forecast_data = get_weather_info(location_info['lat'], location_info['lon'], 'daily')
        @eight_day_forecast = forecast_data.map { |day_data| ForecastData.new(day_data) }
        # Cache the result
        Rails.cache.write(cache_key, forecast_data, expires_in: 30.minutes)
      else
        @error = 'Unable to retrieve forecast data.'
      end
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def set_api_key
    @api_key = Rails.application.credentials.openweathermap[:api_key]
  end

  def get_location_info(zip_code)
    url = URI("https://api.openweathermap.org/geo/1.0/zip?zip=#{zip_code},US&appid=#{@api_key}")

    begin
      response = Net::HTTP.get(url)
      parsed_response = JSON.parse(response)

      # Check if the response contains the expected data
      if parsed_response['lat'].present? && parsed_response['lon'].present?
        parsed_response
      else
        # Handle unexpected or error response
        nil
      end
    rescue StandardError => e
      Rails.logger.error "Failed to get location info: #{e.message}"
      nil
    end
  end

  def get_weather_info(lat, lon, type)
    url = URI("https://api.openweathermap.org/data/3.0/onecall?lat=#{lat}&lon=#{lon}&exclude=minutely,hourly&appid=#{@api_key}")
    response = Net::HTTP.get(url)
    weather_data = JSON.parse(response)

    type == 'current' ? weather_data['current'] : weather_data['daily']
  end
end
