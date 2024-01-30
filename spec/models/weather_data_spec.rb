# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherData do
  subject { described_class.new(valid_data) }

  let(:valid_data) do
    {
      dt: 1_625_150_400, # example Unix timestamp
      sunrise: 1_625_127_600,
      sunset: 1_625_180_400,
      temp: 298.15, # example temperature in Kelvin
      feels_like: 299.15,
      pressure: 1012,
      humidity: 50,
      uvi: 5.34,
      clouds: 20,
      visibility: 10_000,
      weather: [
        {
          icon: '04d',
          description: 'overcast clouds',
          main: 'Clouds'
        }
      ]
    }
  end

  describe '#initialize' do
    it 'initializes with valid data' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#formatted_time' do
    it 'returns formatted UTC time' do
      expect(subject.formatted_time).to eq('2021-07-01 14:40:00 UTC')
    end
  end

  describe '#sunrise' do
    it 'returns formatted sunrise time' do
      expect(subject.sunrise).to eq('2021-07-01 08:20:00 UTC')
    end
  end

  describe '#sunset' do
    it 'returns formatted sunset time' do
      expect(subject.sunset).to eq('2021-07-01 23:00:00 UTC')
    end
  end

  describe '#temperature' do
    it 'converts and returns temperature in Celsius' do
      expect(subject.temperature).to eq(25.0)
    end
  end

  describe '#feels_like' do
    it 'converts and returns feels_like temperature in Celsius' do
      expect(subject.feels_like).to eq(26.0)
    end
  end

  describe '#pressure' do
    it 'returns pressure with unit' do
      expect(subject.pressure).to eq('1012 hPa')
    end
  end

  describe '#humidity' do
    it 'returns humidity with percentage' do
      expect(subject.humidity).to eq('50%')
    end
  end

  describe '#uvi' do
    it 'returns UV index' do
      expect(subject.uvi).to eq(5.34)
    end
  end

  describe '#clouds' do
    it 'returns cloudiness with percentage' do
      expect(subject.clouds).to eq('20%')
    end
  end

  describe '#visibility' do
    it 'returns visibility in kilometers' do
      expect(subject.visibility).to eq('10.0 km')
    end
  end

  describe '#icon' do
    it 'returns the weather icon code' do
      expect(subject.icon).to eq('04d')
    end
  end

  describe '#description' do
    it 'returns the weather description' do
      expect(subject.description).to eq('overcast clouds')
    end
  end

  describe '#main' do
    it 'returns the main weather condition' do
      expect(subject.main).to eq('Clouds')
    end
  end

  # Test for edge cases
  describe 'with incomplete data' do
    subject { described_class.new(incomplete_data) }

    let(:incomplete_data) { { dt: 1_625_150_400 } }

    it 'handles missing data gracefully' do
      expect(subject.sunrise).to be_nil
      expect(subject.temperature).to be_nil
    end
  end
end
