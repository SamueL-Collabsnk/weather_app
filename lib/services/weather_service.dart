import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const String baseURL =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String forecastURL =
      'https://api.openweathermap.org/data/2.5/forecast';
  final String apiKey;

  WeatherService({required this.apiKey});

  //get weather
  Future<Weather> getWeather(String cityName) async {
    try {
      final url = Uri.parse('$baseURL?q=$cityName&appid=$apiKey&units=metric');
      print('[WeatherService] Fetching weather for: $cityName');
      print('[WeatherService] URL: $url');

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout - check your internet connection',
              );
            },
          );

      print('[WeatherService] Response status: ${response.statusCode}');
      print('[WeatherService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your credentials.');
      } else if (response.statusCode == 404) {
        throw Exception(
          'City "$cityName" not found. Please check the spelling.',
        );
      } else {
        throw Exception(
          'Server error (${response.statusCode}): Failed to load weather data',
        );
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection: ${e.message}');
    } catch (e) {
      print('[WeatherService] Error: $e');
      rethrow;
    }
  }

  // Get hourly forecast for next 48 hours
  Future<List<HourlyForecast>> getHourlyForecast(String cityName) async {
    try {
      final url = Uri.parse(
        '$forecastURL?q=$cityName&appid=$apiKey&units=metric&cnt=24',
      );
      print('[WeatherService] Fetching hourly forecast for: $cityName');

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<HourlyForecast> forecasts = [];
        for (var item in data['list']) {
          forecasts.add(HourlyForecast.fromJson(item));
        }
        return forecasts;
      } else {
        throw Exception('Failed to load hourly forecast');
      }
    } catch (e) {
      print('[WeatherService] Hourly forecast error: $e');
      rethrow;
    }
  }

  // Get daily forecast for next 5 days
  Future<List<DailyForecast>> getDailyForecast(String cityName) async {
    try {
      final url = Uri.parse(
        '$forecastURL?q=$cityName&appid=$apiKey&units=metric',
      );
      print('[WeatherService] Fetching daily forecast for: $cityName');

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, DailyForecast> dailyMap = {};

        for (var item in data['list']) {
          final forecast = DailyForecast.fromJson(item);
          final dateKey =
              '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';

          if (!dailyMap.containsKey(dateKey)) {
            dailyMap[dateKey] = forecast;
          } else {
            // Update with better data (noon times are more representative)
            final existing = dailyMap[dateKey]!;
            if (forecast.dateTime.hour > existing.dateTime.hour &&
                forecast.dateTime.hour < 14) {
              dailyMap[dateKey] = forecast;
            }
          }
        }

        return dailyMap.values.toList().take(5).toList();
      } else {
        throw Exception('Failed to load daily forecast');
      }
    } catch (e) {
      print('[WeatherService] Daily forecast error: $e');
      rethrow;
    }
  }

  //get weather city by name
  Future<String> getCurrentCity() async {
    try {
      //get permission from user
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Enable in Settings.',
        );
      }

      print('[WeatherService] Getting current location...');
      //fetch current location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      print(
        '[WeatherService] Location received: ${position.latitude}, ${position.longitude}',
      );

      //convert location into list of place mark objects
      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      //extract city name from place mark object
      String? city = placemark[0].locality;

      if (city == null || city.isEmpty) {
        throw Exception('Could not determine city from location');
      }

      print('[WeatherService] City determined: $city');
      return city;
    } catch (e) {
      print('[WeatherService] Location error: $e');
      rethrow;
    }
  }

  //fetch current position
}
