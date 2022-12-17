import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:tiengviet/tiengviet.dart';

class TouristAttractionProvider extends ChangeNotifier {
  List<TouristAttraction> list = [];

  Future<void> getAll() async {
    String apiURL = "${url.url}/api/tourist";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return TouristAttraction.fromJson(e);
    }).toList();
    notifyListeners();
  }

  List<TouristAttraction> listFilter = [];
  Future filter(id) async {
    String apiURL = "${url.url}/api/tourist/$id";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listFilter = newsListObject.map((e) {
      return TouristAttraction.fromJson(e);
    }).toList();
    notifyListeners();
  }

  List<TouristAttraction> search(String value) {
    List<TouristAttraction> list2 = [];
    for (int i = 0; i < list.length; i++) {
      if (TiengViet.parse(list[i].title.toLowerCase())
          .contains(TiengViet.parse(value.toLowerCase()))) {
        list2.add(list[i]);
      }
    }
    return list2;
  }
}
