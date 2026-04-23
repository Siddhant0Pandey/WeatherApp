import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

Future<void> _fetchWeather() async {
  try {
    final data = await weatherService.getWeather('Kathmandu');
    setState(() {
      weatherData = data;
    });
  } catch (e) {
    print('Error fetching weather: $e');
  }
}

String getWeatherIcon(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return 'lib/assets/sunny.json';
    case 'clouds':
    case 'cloudy':
    case 'mist':
    case 'fog':
      return 'lib/assets/clouds.json';
    case 'rain':
      return 'lib/assets/partlyrain.json';
    case 'snow':
      return 'lib/assets/partlyrain.json';
    default:
      return 'lib/assets/sunny.json';
  }
}

@override
void initState() {
  super.initState();  

_fetchWeather();
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F7FA),
    body: Center(
      child: weatherData == null
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // City
                  const Text(
                    'London',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weather Animation
                  Lottie.asset(
                    getWeatherIcon(weatherData!.mainCondition),
                    width: 160,
                    height: 160,
                  ),

                  const SizedBox(height: 20),

                  // Temperature
                  Text(
                    '${weatherData!.temperature.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    weatherData!.mainCondition.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 1.2,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Divider for minimal feel
                  Container(
                    height: 1,
                    width: 60,
                    color: Colors.black12,
                  ),

                  const SizedBox(height: 20),

                  // Extra info (optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoTile("Temp", "${weatherData!.temperature}°C"),
                      _infoTile("Condition", weatherData!.mainCondition),
                    ],
                  ),
                ],
              ),
            ),
    ),
  );
}

// Reusable minimal info widget
Widget _infoTile(String title, String value) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black45,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
}