import 'package:flutter/material.dart';
import 'package:weathapp/models/weather_model.dart';

class WeatherInfoCard extends StatelessWidget {
  final Weather weather;
  final bool isDarkMode;

  const WeatherInfoCard({
    required this.weather,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.blueGrey[900]!, Colors.blue[900]!]
              : [Colors.blue[400]!, Colors.cyan[300]!],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City and temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    weather.mainCondition,
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${weather.temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Feels like ${weather.feelsLike.round()}°',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Weather details grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: [
              _buildDetailItem(
                icon: Icons.opacity,
                label: 'Humidity',
                value: '${weather.humidity.toInt()}%',
              ),
              _buildDetailItem(
                icon: Icons.air,
                label: 'Wind',
                value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
              ),
              _buildDetailItem(
                icon: Icons.blur_on,
                label: 'Pressure',
                value: '${weather.pressure} mb',
              ),
              _buildDetailItem(
                icon: Icons.cloud_queue,
                label: 'Visibility',
                value: '${weather.visibility.toStringAsFixed(1)} km',
              ),
              _buildDetailItem(
                icon: Icons.wb_sunny_outlined,
                label: 'Sunrise',
                value: _formatTime(weather.sunrise),
              ),
              _buildDetailItem(
                icon: Icons.nights_stay_outlined,
                label: 'Sunset',
                value: _formatTime(weather.sunset),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
