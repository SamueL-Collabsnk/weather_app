import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weathapp/models/weather_provider.dart';
import 'package:weathapp/widgets/daily_forecast.dart';
import 'package:weathapp/widgets/hourly_forecast.dart';
import 'package:weathapp/widgets/search_city.dart';
import 'package:weathapp/widgets/weather_info_card.dart';

import '../models/theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  void _initializeWeather() async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API key not found. Check .env file.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    _weatherProvider = context.read<WeatherProvider>();
    _weatherProvider.initialize(apiKey);

    if (mounted) {
      await _weatherProvider.fetchWeatherForCurrentLocation();
    }
  }

  String getWeatherAnimations({
    required String? mainCondition,
    required String? iconCode,
    required int? cloudPercent,
  }) {
    if (mainCondition == null || iconCode == null) {
      return 'assets/notfound.json';
    }

    final isNight = iconCode.endsWith('n');
    final lowerCondition = mainCondition.toLowerCase();

    if (lowerCondition == 'clear' && isNight) {
      return 'assets/moon.json';
    }

    if (lowerCondition == 'clouds' &&
        (cloudPercent != null && cloudPercent <= 50)) {
      return 'assets/sunny_cloudy.json';
    }

    switch (lowerCondition) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rain.json';
      case 'drizzle':
        return 'assets/drizzle.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'mist':
      case 'haze':
      case 'fog':
        return 'assets/foggy.json';
      default:
        return 'assets/notfound.json';
    }
  }

  String _getGreetings() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning! 🌄';
    } else if (hour < 17) {
      return 'Good Afternoon! 🕑';
    } else if (hour < 20) {
      return 'Good Evening! 🌆';
    } else {
      return 'Good Night! 🌃';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[50],
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading && weatherProvider.weather == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading weather data...'),
                ],
              ),
            );
          }

          if (weatherProvider.error != null &&
              weatherProvider.weather == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 20),
                  Text(
                    weatherProvider.error!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      weatherProvider.fetchWeatherForCurrentLocation();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final weather = weatherProvider.weather;
          if (weather == null) {
            return const Center(child: Text('No weather data available'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await weatherProvider.fetchWeatherForCurrentLocation();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with greeting and theme toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getGreetings(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  weatherProvider
                                      .fetchWeatherForCurrentLocation();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  themeProvider.toggleTheme();
                                },
                                icon: Icon(
                                  themeProvider.isDarkMode
                                      ? Icons.wb_sunny_outlined
                                      : Icons.nightlight_round,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Search bar
                    SearchCityWidget(
                      isDarkMode: isDarkMode,
                      onSearch: (cityName) {
                        weatherProvider.searchCity(cityName);
                      },
                    ),

                    const SizedBox(height: 10),

                    // Main weather info card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Weather animation
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Lottie.asset(
                              getWeatherAnimations(
                                mainCondition: weather.mainCondition,
                                iconCode: weather.iconCode,
                                cloudPercent: weather.cloudPercentage,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Weather info card
                          WeatherInfoCard(
                            weather: weather,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),

                    // Show loading indicator if fetching forecasts
                    if (weatherProvider.isLoading &&
                        weatherProvider.weather != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),

                    // Hourly forecast
                    if (weatherProvider.hourlyForecast.isNotEmpty)
                      HourlyForecastWidget(
                        forecasts: weatherProvider.hourlyForecast,
                        isDarkMode: isDarkMode,
                      ),

                    // Daily forecast
                    if (weatherProvider.dailyForecast.isNotEmpty)
                      DailyForecastWidget(
                        forecasts: weatherProvider.dailyForecast,
                        isDarkMode: isDarkMode,
                      ),

                    // Error message for forecasts
                    if (weatherProvider.error != null &&
                        weatherProvider.weather != null)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Forecast: ${weatherProvider.error}',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
