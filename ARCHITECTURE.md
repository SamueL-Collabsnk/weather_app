# Weather App - Architecture & Technical Documentation

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  ┌──────────────────────────────────┐   │
│  │      WeatherScreen (UI)           │   │
│  │ ┌────────────────────────────┐   │   │
│  │ │ - Header (greeting, theme)  │   │   │
│  │ │ - Weather Info Card         │   │   │
│  │ │ - Hourly Forecast           │   │   │
│  │ │ - Daily Forecast            │   │   │
│  │ │ - Search Widget             │   │   │
│  │ └────────────────────────────┘   │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│      State Management Layer             │
│  ┌──────────────────────────────────┐   │
│  │  WeatherProvider (Provider)       │   │
│  │  ┌──────────────────────────┐    │   │
│  │  │ - Current weather        │    │   │
│  │  │ - Hourly forecasts       │    │   │
│  │  │ - Daily forecasts        │    │   │
│  │  │ - Loading state          │    │   │
│  │  │ - Error handling         │    │   │
│  │  │ - Auto-refresh timer     │    │   │
│  │  └──────────────────────────┘    │   │
│  └──────────────────────────────────┘   │
│  ┌──────────────────────────────────┐   │
│  │  ThemeProvider (Provider)         │   │
│  │  ┌──────────────────────────┐    │   │
│  │  │ - Dark/Light mode toggle │    │   │
│  │  └──────────────────────────┘    │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│       Business Logic Layer              │
│  ┌──────────────────────────────────┐   │
│  │  WeatherService                   │   │
│  │  ┌──────────────────────────┐    │   │
│  │  │ - getWeather(city)       │    │   │
│  │  │ - getHourlyForecast()    │    │   │
│  │  │ - getDailyForecast()     │    │   │
│  │  │ - getCurrentCity()       │    │   │
│  │  └──────────────────────────┘    │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│       Data/Services Layer               │
│  ┌──────────────────────────────────┐   │
│  │ External Services                │   │
│  │ ┌──────────────────────────┐    │   │
│  │ │ - OpenWeatherMap API     │    │   │
│  │ │ - Geolocator (GPS)       │    │   │
│  │ │ - Geocoding (coords→city)│    │   │
│  │ │ - PermissionHandler      │    │   │
│  │ └──────────────────────────┘    │   │
│  └──────────────────────────────────┘   │
│  ┌──────────────────────────────────┐   │
│  │ Models                            │   │
│  │ ┌──────────────────────────┐    │   │
│  │ │ - Weather                │    │   │
│  │ │ - HourlyForecast         │    │   │
│  │ │ - DailyForecast          │    │   │
│  │ └──────────────────────────┘    │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

## 📦 Data Models

### Weather Model

```dart
class Weather {
  String cityName;           // e.g., "London"
  double temperature;        // in Celsius
  String mainCondition;      // e.g., "Clear", "Clouds"
  String iconCode;           // e.g., "01d", "02n"
  int cloudPercentage;       // 0-100%
  double feelsLike;          // Perceived temperature
  double humidity;           // Percentage
  double windSpeed;          // m/s
  int pressure;              // hPa
  double visibility;         // km
  DateTime sunrise;          // Local time
  DateTime sunset;           // Local time
}
```

### HourlyForecast Model

```dart
class HourlyForecast {
  DateTime dateTime;         // Prediction time
  double temperature;        // in Celsius
  String condition;          // Weather condition
  String iconCode;           // Weather icon code
  double windSpeed;          // m/s
  int humidity;              // Percentage
}
```

### DailyForecast Model

```dart
class DailyForecast {
  DateTime dateTime;         // Day of forecast
  double tempMax;            // Maximum temperature
  double tempMin;            // Minimum temperature
  String condition;          // Weather condition
  String iconCode;           // Weather icon code
  double windSpeed;          // m/s
  int humidity;              // Percentage
  double chanceOfRain;       // Percentage (0-100)
}
```

## 🔄 Data Flow

### 1. App Initialization

```
main.dart
  ↓
Provider Setup (Theme + Weather)
  ↓
WeatherScreen loads
  ↓
WeatherProvider.initialize(apiKey)
  ↓
WeatherProvider.fetchWeatherForCurrentLocation()
```

### 2. Getting Current Weather

```
WeatherProvider.fetchWeatherForCurrentLocation()
  ↓
WeatherService.getCurrentCity()
  ↓
Geolocator.getCurrentPosition() [Gets GPS coordinates]
  ↓
Geocoding.placemarkFromCoordinates() [Converts to city name]
  ↓
WeatherProvider.fetchAllWeatherData(cityName)
  ↓
Three parallel API calls:
  ├─ WeatherService.getWeather() [Current weather]
  ├─ WeatherService.getHourlyForecast() [Next 24 hours]
  └─ WeatherService.getDailyForecast() [5-day forecast]
  ↓
Update WeatherProvider state
  ↓
UI re-renders with new data
```

### 3. Searching for a City

```
User enters city name in SearchCityWidget
  ↓
SearchCityWidget.onSearch(cityName)
  ↓
WeatherProvider.searchCity(cityName)
  ↓
WeatherProvider.fetchAllWeatherData(cityName)
  ↓
[Same as above - three API calls]
  ↓
UI updates
```

### 4. Auto-Refresh

```
WeatherProvider._startAutoRefresh()
  ↓
Timer.periodic(10 minutes)
  ↓
WeatherProvider.fetchAllWeatherData(_currentCity)
  ↓
UI updates silently
```

## 🌐 API Integration

### Endpoint 1: Current Weather

```
GET /data/2.5/weather?q={city}&appid={apiKey}&units=metric

Response:
{
  "coord": { "lon": ..., "lat": ... },
  "weather": [{ "id": ..., "main": "Clear", "icon": "01d" }],
  "main": {
    "temp": 22.5,
    "feels_like": 21.8,
    "humidity": 65,
    "pressure": 1013,
    ...
  },
  "visibility": 10000,
  "wind": { "speed": 5.5, "deg": 230 },
  "clouds": { "all": 10 },
  "sys": {
    "sunrise": 1640000000,
    "sunset": 1640040000
  },
  "name": "London"
}
```

### Endpoint 2: Forecast (24h + 5d)

```
GET /data/2.5/forecast?q={city}&appid={apiKey}&units=metric&cnt=40

Response:
{
  "list": [
    {
      "dt": 1640000000,
      "main": {
        "temp": 21.5,
        "temp_max": 23.0,
        "temp_min": 20.0,
        "humidity": 70
      },
      "weather": [{ "main": "Clouds", "icon": "02d" }],
      "wind": { "speed": 4.2 },
      "pop": 0.15,  // Probability of precipitation
      ...
    },
    ...
  ]
}
```

## 📊 State Management (Provider)

### WeatherProvider

```dart
class WeatherProvider extends ChangeNotifier {
  // State
  Weather? _weather;
  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];
  bool _isLoading = false;
  String? _error;

  // Public methods
  void initialize(String apiKey) {}
  Future<void> fetchWeatherForCurrentLocation() {}
  Future<void> fetchAllWeatherData(String cityName) {}
  Future<void> searchCity(String cityName) {}

  // Private methods
  void _startAutoRefresh() {}
  void _setLoading(bool value) {}
  void _setError(String? error) {}
  void _clearError() {}
}
```

## 🎨 Widget Tree

```
MyApp (Material App)
  ├── WeatherScreen
  │   └── SafeArea
  │       └── SingleChildScrollView (RefreshIndicator)
  │           └── Column
  │               ├── Header Row
  │               │   ├── Greeting Text
  │               │   └── Icon Buttons (Refresh, Theme)
  │               ├── SearchCityWidget
  │               ├── Padding
  │               │   └── Column
  │               │       ├── Lottie Animation
  │               │       └── WeatherInfoCard
  │               │           └── GridView (6 weather details)
  │               ├── HourlyForecastWidget
  │               │   └── SingleChildScrollView (Horizontal)
  │               │       └── Row (HourlyCards)
  │               ├── DailyForecastWidget
  │               │   └── ListView (DailyCards)
  │               └── Error Message (if any)
```

## 🔐 Permission Flow

### Android

```
App Start
  ↓
Geolocator.checkPermission()
  ├─ GRANTED? → Use GPS
  ├─ DENIED? → requestPermission()
  │  ├─ User grants? → Use GPS
  │  └─ User denies? → Show error, allow search
  └─ DENIED_FOREVER? → Show alert, allow search
```

### iOS

```
App Start
  ↓
First GPS access
  ├─ iOS shows native popup
  ├─ User allows? → Use GPS
  └─ User denies? → Fallback to search
```

## 🔄 API Error Handling

```dart
try {
  // API call
} on SocketException {
  // No internet
  "No internet connection"
} catch (e) {
  if (statusCode == 401) {
    "Invalid API key"
  } else if (statusCode == 404) {
    "City not found"
  } else if (statusCode == timeout) {
    "Request timeout"
  } else {
    "Server error"
  }
}
```

## ⚡ Performance Considerations

1. **API Calls**: Parallel execution using `Future.wait()`
2. **Widget Rebuilds**: Provider only rebuilds relevant widgets
3. **Animations**: Lottie animations are pre-loaded
4. **Memory**: Forecasts stored in memory (1 session)
5. **Network**: 10-second timeout per request
6. **Auto-Refresh**: 10-minute intervals (configurable)

## 📱 Responsive Design

- **Mobile First**: Optimized for phones
- **Scrollable**: SingleChildScrollView for all content
- **Flexible**: Adapts to different screen sizes
- **Safe Areas**: Respects notches and safe zones
- **Orientation**: Supports portrait and landscape

## 🎯 Testing Checklist

```
✓ GPS location works
✓ Current weather displays
✓ Hourly forecast shows 24 items
✓ Daily forecast shows 5 items
✓ Search functionality works
✓ Theme toggle works
✓ Pull to refresh works
✓ Auto-refresh triggers
✓ Error handling shows messages
✓ Loading indicators display
✓ All animations play smoothly
✓ Dark mode colors correct
✓ Light mode colors correct
✓ Permissions flow works
```

## 🚀 Deployment Checklist

```
Android:
  ✓ minSdk >= 21
  ✓ Permissions in manifest
  ✓ API key in .env
  ✓ buildTypes configured
  ✓ Release key configured

iOS:
  ✓ Deployment target >= 12.0
  ✓ Info.plist descriptions added
  ✓ Pods updated
  ✓ Xcode build settings verified
  ✓ API key in .env

Both:
  ✓ flutter clean && flutter pub get
  ✓ flutter analyze passes
  ✓ Tested on physical devices
  ✓ All permissions working
  ✓ No console errors
```

---

This documentation provides a complete technical overview of the updated weather app architecture and data flow.
