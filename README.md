# WeatherWise: Real-Time Weather Forecasts

## Introduction

WeatherWise is your go-to application for real-time weather forecasts. Simply enter an address, and get instant access to the current temperature, daily high/low, and extended forecasts. With an efficient 30-minute caching system, WeatherWise ensures you stay informed with minimal delay!

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Before you begin, ensure you have the following installed:
- Ruby version 3.1.0
- Rails (version specified in Gemfile)

### Installation

1. **Clone the repository**
```git clone [repository URL]```

2. **Navigate to the directory**
```cd path-to-folder```

3. **Install dependencies**
```bundle install```

4. **Start the Rails server**
```rails s```


5. **Access the Application**
Open your browser and visit `localhost:3000`. Enter your desired zipcode to receive the latest weather forecasts.

## Running the Tests

To run all the test suite and ensure everything is functioning as expected:
```bundle exec rspec```

## Features

- **Real-time weather data:** Access up-to-date weather information.
- **Efficient caching:** 30-minute caching for faster, more efficient performance.
- **User-friendly interface:** Easy to navigate and use.