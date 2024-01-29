# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    appid = Rails.application.credentials.openweathermap[:api_key]
    zipcode = '91356'
    country = 'US'
    url = "http://api.openweathermap.org/geo/1.0/zip?zip=#{zipcode},#{country}&appid=#{appid}"
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    @data = JSON.parse(res.body)
  end
end
