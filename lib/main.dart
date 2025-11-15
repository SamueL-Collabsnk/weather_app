import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weathapp/models/theme.dart';
import 'package:weathapp/screens/weather_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Weather App',
      home: WeatherScreen(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.thememode,
    );
  }
}
