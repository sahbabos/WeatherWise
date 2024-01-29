Rails.application.routes.draw do
  # Other routes
  root "home#index"
  get 'weather/:zip_code', to: 'weather#show', as: :current_weather
  get 'weather_forecast/:zip_code', to: 'weather#index', as: :weather_forecast
end