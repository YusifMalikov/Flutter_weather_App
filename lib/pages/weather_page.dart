/*import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('4f9c27eb8b843461b91e20b24a414de0');
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    try {
      // Get current city
      String cityName = await _weatherService.getCurrentCity();
      // Get weather for this city
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(_weather?.cityName ?? "Loading city..."),
            SizedBox(height: 10),

            // Temperature
            Text(
              _weather != null
                  ? '${_weather!.temperature.round()} °C'
                  : 'Loading temperature...',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('4f9c27eb8b843461b91e20b24a414de0');
  Weather? _weather;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
    });

    String cityName;

    // Get current city safely
    try {
      cityName = await _weatherService.getCurrentCity();
      if (cityName.isEmpty) cityName = "Berlin"; // fallback
    } catch (e) {
      cityName = "Berlin"; // fallback if location fails
      print("Error getting location: $e");
    }

    // Get weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error fetching weather: $e");
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';
    
    switch(mainCondition.toLowerCase()){
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/cloud.json';
      case "rain":
      case "drizzle":
      case "shower rain":
        return 'assets/rain.json';
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
      

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _weather == null
                ? const Text("Failed to load weather data")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // City name
                      Text(
                        _weather!.cityName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Lottie animation (auto size)
                      Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                      const SizedBox(height: 20),

                      // Temperature
                      Text(
                        '${_weather!.temperature.round()} °C',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500),
                      ),
                      // weather condition
                      Text(_weather?.mainCondition ?? "")
                    ],
                  ),
      ),
    );
  }
}