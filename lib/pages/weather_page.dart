import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

final WeatherService weatherService = WeatherService('99a81e84c186087c9d0581629216328c');

WeatherModel? weatherData;

_fetchWeather() async {
  try {
    final data = await weatherService.getWeather('London');
    setState(() {
      weatherData = data;
    });
  } catch (e) {
    print('Error fetching weather: $e');
  }
}


void initState() {
  super.initState();  

_fetchWeather();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Weather Page'),
          if (weatherData != null) ...[
            Text('Temperature: ${weatherData!.temprature}°C'),
            Text('Description: ${weatherData!.description}'),
          ],
        ],
      ),
    );
  }
}