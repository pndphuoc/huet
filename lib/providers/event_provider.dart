import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hue_t/model/event/event.dart';

class EventProvider extends ChangeNotifier {
  List<Event> list = [];

  Future<void> getAll() async {
    String apiURL = "http://localhost:8888/api/event";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return Event.fromJson(e);
    }).toList();
    notifyListeners();
  }
}
