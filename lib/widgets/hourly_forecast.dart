import 'package:flutter/material.dart';
import 'package:weathapp/models/weather_model.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecast> forecasts;
  final bool isDarkMode;

  const HourlyForecastWidget({
    required this.forecasts,
    required this.isDarkMode,
    super.key,
  });

  String _getWeatherEmoji(String condition) {
    final lowerCondition = condition.toLowerCase();
    switch (lowerCondition) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'haze':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Hourly Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(
                forecasts.length,
                (index) => _buildHourlyCard(forecasts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyCard(HourlyForecast forecast) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            _formatTime(forecast.dateTime),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getWeatherEmoji(forecast.condition),
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 10),
          Text(
            '${forecast.temperature.round()}°C',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '💨 ${forecast.windSpeed.toStringAsFixed(1)} m/s',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:00';
  }
}
