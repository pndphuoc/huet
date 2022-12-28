import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Weather {
  List weather;
  dynamic main;
  Weather({required this.weather, required this.main});
  factory Weather.fromJson(Map<String, dynamic> obj) {
    return Weather(weather: obj['weather'], main: obj['main']);
  }
}

class WeatherProvider extends ChangeNotifier {
  bool isloading = true;

  Weather currentweather = Weather(weather: [
    {'main': '...'}
  ], main: {
    'feels_like': 0
  });
  Future<void> getWeather() async {
    String apiURL =
        "https://openweathermap.org/data/2.5/weather?id=1580240&appid=439d4b804bc8187953eb36d2a8c26a02";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    currentweather =
        Weather(weather: jsonObject['weather'], main: jsonObject['main']);

    notifyListeners();
  }
}
