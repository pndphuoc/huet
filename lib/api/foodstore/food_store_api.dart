// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

import '../../model/foodstore/restaurant.dart';

Future<bool> getapi() async {
  final response = await http.get(
    Uri.parse('http://172.20.10.5:8888/api/foodstore'),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return false;
  }
}

List<Restaurant> list = [];

Future gettop() async {
  String apiURL = "http://172.20.10.5:8888/api/foodstore/gettop";
  var client = http.Client();
  var jsonString = await client.post(Uri.parse(apiURL));
  var jsonObject = jsonDecode(jsonString.body);
  var newsListObject = jsonObject as List;
  list = newsListObject.map((e) {
    return Restaurant.fromJson(e);
  }).toList();
}

List<Restaurant> listSearch = [];

Future search(id) async {
  String apiURL = "http://172.20.10.5:8888/api/foodstore/search/3";
  var client = http.Client();
  var jsonString = await client.get(Uri.parse(apiURL));
  var jsonObject = jsonDecode(jsonString.body);
  var newsListObject = jsonObject as List;
  listSearch = newsListObject.map((e) {
    return Restaurant.fromJson(e);
  }).toList();
}

List<Restaurant> list2 = list.map((e) => e).toList();

sort() {
  list2.sort((b, a) {
    return a.rating!.compareTo(b.rating!);
  });
}
