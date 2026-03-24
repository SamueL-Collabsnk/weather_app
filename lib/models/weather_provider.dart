import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weathapp/models/weather_model.dart';
import 'package:weathapp/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];
  bool _isLoading = false;
  String? _error;
  String _currentCity = '';
  late WeatherService _weatherService;
  Timer? _refreshTimer;

  // Getters
  Weather? get weather => _weather;
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;
  List<DailyForecast> get dailyForecast => _dailyForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;

  WeatherProvider();

  void initialize(String apiKey) {
    _weatherService = WeatherService(apiKey: apiKey);
    // Auto-refresh every 10 minutes
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      if (_currentCity.isNotEmpty) {
        fetchAllWeatherData(_currentCity);
      }
    });
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    try {
      _setLoading(true);
      _clearError();

      final cityName = await _weatherService.getCurrentCity();
      _currentCity = cityName;

      await fetchAllWeatherData(cityName);
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      debugPrint("Location fetch error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllWeatherData(String cityName) async {
    try {
      _setLoading(true);
      _clearError();
      _currentCity = cityName;

      final weatherFuture = _weatherService.getWeather(cityName);
      final hourlyFuture = _weatherService.getHourlyForecast(cityName);
      final dailyFuture = _weatherService.getDailyForecast(cityName);

      final results = await Future.wait([
        weatherFuture,
        hourlyFuture,
        dailyFuture,
      ]);

      _weather = results[0] as Weather;
      _hourlyForecast = results[1] as List<HourlyForecast>;
      _dailyForecast = results[2] as List<DailyForecast>;

      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      debugPrint("Weather fetch error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchCity(String cityName) async {
    await fetchAllWeatherData(cityName);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
