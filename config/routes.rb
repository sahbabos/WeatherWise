# frozen_string_literal: true

Rails.application.routes.draw do
  # Other routes
  # resources :weather
  root 'home#index'
  # config/routes.rb
  get 'weather', to: 'weather#show', as: 'weather'
  get 'weather_forecast/:zip_code', to: 'weather#index', as: :weather_forecast

  # get 'weather/:zip_code', to: 'weather#show', as: :current_weather
  # get 'weather_forecast/:zip_code', to: 'weather#index', as: :weather_forecast
  # config/routes.rb
  # get 'weather', to: 'weather#show'
end
