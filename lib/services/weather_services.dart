import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_model.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  // 🔹 Get weather by city name
  Future<WeatherModel> getWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
    );

    return _fetchWeather(url);
  }

  // 🔹 Get weather by coordinates (BEST for real apps)
  Future<WeatherModel> getWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    return _fetchWeather(url);
  }

  // 🔹 Common fetch logic (clean & reusable)
  Future<WeatherModel> _fetchWeather(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return WeatherModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to load weather data',
        );
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}