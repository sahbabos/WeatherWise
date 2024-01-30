# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/AnyInstance
RSpec.describe WeatherController, type: :controller do
  describe 'GET #show' do
    let(:zip_code) { '12345' }

    context 'when data is cached' do
      before do
        # Mock Rails.cache to return valid cached data
        allow(Rails.cache).to receive(:read).with(zip_code).and_return(WeatherData.new({ temp: 295,
                                                                                         dt: Time.now.to_i }))
        get :show, params: { zip_code: }
      end

      it 'assigns @weather_data from cache' do
        expect(assigns(:weather_data)).not_to be_nil
      end

      it 'sets @from_cache to true' do
        expect(assigns(:from_cache)).to be true
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when data is not cached' do
      let(:api_response) { { 'current' => { 'temp' => 295, 'dt' => Time.now.to_i } } }

      before do
        allow(Rails.cache).to receive(:read).with(zip_code).and_return(nil)
        allow(Rails.cache).to receive(:write).with(any_args)
        get :show, params: { zip_code: }
      end

      it 'fetches data using API call' do
        expect(assigns(:weather_data)).not_to be_nil
      end

      it 'caches the new data' do
        expect(Rails.cache).to have_received(:write).with(zip_code, anything, expires_in: 30.minutes)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when API call fails' do
      before do
        allow(Rails.cache).to receive(:read).with(zip_code).and_return(nil)
        allow_any_instance_of(described_class).to receive(:get_location_info).with(zip_code).and_return(nil)
        get :show, params: { zip_code: }
      end

      it 'sets an error message' do
        expect(assigns(:error)).to eq('Unable to retrieve weather data.')
      end

      it 'does not set @weather_data' do
        expect(assigns(:weather_data)).to be_nil
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #index' do
    let(:zip_code) { '12345' }
    let(:cache_key) { "#{zip_code}_8_day_forecast" }

    context 'when data is cached' do
      it 'retrieves data from cache' do
        # Use an actual hash with the expected structure
        cached_data = [{
          dt: 1_609_437_200,
          summary: 'Partly cloudy',
          temp: { day: 298.15, night: 295.15 },
          humidity: 80,
          pressure: 1012,
          uvi: 3.5,
          weather: [{ main: 'Clouds', description: 'scattered clouds', icon: '03d' }]
        }]
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(cached_data)

        get :index, params: { zip_code: }

        expect(assigns(:eight_day_forecast)).not_to be_empty
        expect(assigns(:from_cache)).to be true
      end
    end

    context 'when data is not cached' do
      it 'fetches new data and caches it' do
        forecast_data = [
          {
            dt: 1_609_437_200,
            summary: 'Partly cloudy',
            temp: { day: 298.15, night: 295.15 },
            humidity: 80,
            pressure: 1012,
            uvi: 3.5,
            weather: [{ main: 'Clouds', description: 'scattered clouds', icon: '03d' }]
          }
        ]

        allow_any_instance_of(described_class).to receive(:get_weather_info).and_return(forecast_data)
        get :index, params: { zip_code: }

        expect(assigns(:eight_day_forecast).first).to be_a(ForecastData)
        expect(assigns(:from_cache)).to be false
      end
    end

    context 'when API call fails' do
      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(nil)
        allow_any_instance_of(described_class).to receive(:get_location_info).with(zip_code).and_return(nil)
      end

      it 'sets an error message' do
        get :index, params: { zip_code: }

        expect(assigns(:error)).to eq('Unable to retrieve forecast data.')
      end
    end
  end
  # rubocop:enable RSpec/AnyInstance
end
