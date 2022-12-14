import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hue_t/model/event/event.dart';
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:tiengviet/tiengviet.dart';

class EventProvider extends ChangeNotifier {
  List<Event> list = [];
  List<Event> listThisMonth = [];
  List<Event> listNextMonth = [];
  List<Event> listSearch = [];
  bool isloading = true;

  Future<void> getAll() async {
    String apiURL = "${url.url}/api/event";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return Event.fromJson(e);
    }).toList();
    notifyListeners();
  }

  Future<void> getThisMonth() async {
    String apiURL = "${url.url}/api/event/geteventthismonth";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listThisMonth = newsListObject.map((e) {
      return Event.fromJson(e);
    }).toList();
    notifyListeners();
  }

  Future<void> getNextMonth() async {
    String apiURL = "${url.url}/api/event/geteventnextmonth";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listNextMonth = newsListObject.map((e) {
      return Event.fromJson(e);
    }).toList();
    notifyListeners();
  }

  Future<void> searchItem(String value) async {
    listSearch = [];
    notifyListeners();

    for (int i = 0; i < list.length; i++) {
      if (TiengViet.parse(list[i].name.toString().toLowerCase())
          .contains(TiengViet.parse(value.toLowerCase()))) {
        listSearch.add(list[i]);
        notifyListeners();
      }
    }
  }
}
