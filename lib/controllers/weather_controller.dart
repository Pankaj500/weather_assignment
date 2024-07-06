import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:weather_assignment/models/weather_model.dart';
import 'package:weather_assignment/views/homepage.dart';
import 'package:weather_assignment/views/weather_details.dart';

final weatherprovider = StateProvider<WeatherModel>((ref) {
  WeatherModel weatherModel = WeatherModel();

  return weatherModel;
});

class WeatherController {
  Future<bool> weatherdata(
      WidgetRef ref, String location, BuildContext context) async {
    try {
      ref.read(isloadingprovider.notifier).state = true;

      WeatherModel weatherModel = WeatherModel();

      Response response = await http.get(
        Uri.parse(
            'http://api.weatherapi.com/v1/current.json?key=f9fa47abd20f4acf9dc51756240407&q=$location&aqi=no'),
      );

      var reponsedate = response.body;

      print(response.statusCode);

      if (response.statusCode == 200) {
        ref.read(isloadingprovider.notifier).state = false;

        weatherModel = WeatherModel.fromJson(jsonDecode(reponsedate));

        ref.read(weatherprovider.notifier).state = weatherModel;

        return true;
      } else {
        ref.read(isloadingprovider.notifier).state = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('enter city is not correct or any unknown error')));
        return false;
      }
    } catch (e) {
      ref.read(isloadingprovider.notifier).state = false;

      throw Text(e.toString());
    }
  }
}
