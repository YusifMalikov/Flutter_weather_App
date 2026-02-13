import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as  http;

class WeatherService {

  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather data!');
    }
  }
// get permission
  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    //fetch the current loc
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
  );
    //convert the location into a list of placemark jects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
