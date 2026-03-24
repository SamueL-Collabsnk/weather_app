class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String iconCode;
  final int cloudPercentage;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final int pressure;
  final double visibility;
  final DateTime sunrise;
  final DateTime sunset;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.iconCode,
    required this.cloudPercentage,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      cloudPercentage: json['clouds']['all'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      visibility: (json['visibility'] ?? 10000).toDouble() / 1000,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunrise'] * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
    );
  }
}

class HourlyForecast {
  final DateTime dateTime;
  final double temperature;
  final String condition;
  final String iconCode;
  final double windSpeed;
  final int humidity;

  HourlyForecast({
    required this.dateTime,
    required this.temperature,
    required this.condition,
    required this.iconCode,
    required this.windSpeed,
    required this.humidity,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
    );
  }
}

class DailyForecast {
  final DateTime dateTime;
  final double tempMax;
  final double tempMin;
  final String condition;
  final String iconCode;
  final double windSpeed;
  final int humidity;
  final double chanceOfRain;

  DailyForecast({
    required this.dateTime,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.iconCode,
    required this.windSpeed,
    required this.humidity,
    required this.chanceOfRain,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['main']['temp_max'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      condition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      chanceOfRain: (json['pop'] ?? 0).toDouble() * 100,
    );
  }
}
