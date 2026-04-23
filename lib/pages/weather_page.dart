import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/main.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService =
      WeatherService('99a81e84c186087c9d0581629216328c');

  WeatherModel? weatherData;

  final TextEditingController _controller = TextEditingController();

  Future<void> _fetchWeather([String? city]) async {
    try {
      final data = await weatherService.getWeather(
        city ?? 'Kathmandu',
      );

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
        return 'assets/sunny.json';
      case 'clouds':
      case 'cloudy':
      case 'mist':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
        return 'assets/partlyrain.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🔍 Search Bar
              TextField(
                controller: _controller,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: "Search city...",
                  hintStyle: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search,
                        color: theme.iconTheme.color),
                    onPressed: () {
                      final city = _controller.text.trim();
                      if (city.isNotEmpty) {
                        _fetchWeather(city);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _fetchWeather(value);
                    _controller.clear();
                  }
                },
              ),

              const SizedBox(height: 30),

              // 🔄 Content
              Expanded(
                child: Center(
                  child: weatherData == null
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // City
                            Text(
                              weatherData!.cityName,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Animation
                            Lottie.asset(
                              getWeatherIcon(
                                  weatherData!.mainCondition),
                              width: 160,
                              height: 160,
                            ),

                            const SizedBox(height: 20),

                            // Temperature
                            Text(
                              '${weatherData!.temperature.toStringAsFixed(1)}°',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Condition
                            Text(
                              weatherData!.mainCondition.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),

                            const SizedBox(height: 30),

                            Container(
                              height: 1,
                              width: 60,
                              color: theme.dividerColor,
                            ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                _infoTile(
                                  context,
                                  "Temp",
                                  "${weatherData!.temperature}°C",
                                ),
                                _infoTile(
                                  context,
                                  "Condition",
                                  weatherData!.mainCondition,
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 🌙 Floating Theme Toggle Button (BOTTOM RIGHT)
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: theme.cardColor,
        onPressed: () {
          MyApp.of(context).toggleTheme();
        },
        child: Icon(
          MyApp.of(context).isDark
              ? Icons.light_mode
              : Icons.dark_mode,
          color: theme.iconTheme.color,
        ),
      ),
    );
  }

  Widget _infoTile(BuildContext context, String title, String value) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}