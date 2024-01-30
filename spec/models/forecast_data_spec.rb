# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastData do
  subject { described_class.new(valid_forecast_data) }

  let(:valid_forecast_data) do
    {
      dt: 1_625_150_400, # example Unix timestamp for date
      summary: 'Partly cloudy',
      temp: { day: 298.15, night: 293.15 }, # temperatures in Kelvin
      humidity: 60,
      pressure: 1010,
      uvi: 6.78,
      weather: [{ main: 'Clouds', description: 'scattered clouds', icon: '03d' }]
    }
  end

  describe '#initialize' do
    it 'initializes with valid forecast data' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#date' do
    it 'returns the date in Date format' do
      expect(subject.date).to eq(Date.parse('2021-07-01'))
    end
  end

  describe '#summary' do
    it 'returns the weather summary' do
      expect(subject.summary).to eq('Partly cloudy')
    end
  end

  describe '#temp_day' do
    it 'converts and returns day temperature in Celsius' do
      expect(subject.temp_day).to eq(25.0) # 298.15 Kelvin is 25 Celsius
    end
  end

  describe '#temp_night' do
    it 'converts and returns night temperature in Celsius' do
      expect(subject.temp_night).to eq(20.0) # 293.15 Kelvin is 20 Celsius
    end
  end

  describe '#humidity' do
    it 'returns the humidity' do
      expect(subject.humidity).to eq(60)
    end
  end

  describe '#pressure' do
    it 'returns the pressure' do
      expect(subject.pressure).to eq(1010)
    end
  end

  describe '#uvi' do
    it 'returns the UV index' do
      expect(subject.uvi).to eq(6.78)
    end
  end

  describe '#weather' do
    context 'when weather data is present' do
      it 'returns the first weather condition with string keys' do
        expected_weather = valid_forecast_data[:weather].first.transform_keys(&:to_s)
        expect(subject.weather).to eq(expected_weather)
      end
    end

    context 'when weather data is absent' do
      let(:valid_forecast_data) { { dt: 1_625_150_400, temp: { day: 298.15, night: 293.15 } } }

      it 'returns nil' do
        expect(subject.weather).to be_nil
      end
    end
  end

  # Test for edge cases
  describe 'with incomplete data' do
    subject { described_class.new(incomplete_data) }

    let(:incomplete_data) { { dt: 1_625_150_400 } }

    it 'handles missing data gracefully' do
      expect(subject.summary).to be_nil
      expect(subject.temp_day).to be_nil
    end
  end
end
