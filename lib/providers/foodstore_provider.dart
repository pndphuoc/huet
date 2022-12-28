import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:tiengviet/tiengviet.dart';
import '../model/foodstore/restaurant.dart';
import 'package:hue_t/constants/host_url.dart' as url;

class FoodstoreProvider extends ChangeNotifier {
  bool isloading = true;
  List<Restaurant> list = [];
  List<Restaurant> listfull = [];
  List<Restaurant> listSearch = [];
  String addresss = "";

  Future<void> getapi() async {
    String apiURL = "${url.url}/api/foodstore";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listfull = newsListObject.map((e) {
      return Restaurant.fromJson(e);
    }).toList();
  }

  Future<void> gettop() async {
    String apiURL = "${url.url}/api/foodstore/gettop";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return Restaurant.fromJson(e);
    }).toList();
    notifyListeners();
  }

  Future search(id) async {
    String apiURL = "${url.url}/api/foodstore/search/${id}";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listSearch = newsListObject.map((e) {
      return Restaurant.fromJson(e);
    }).toList();
    notifyListeners();
  }

  sort() {
    List<Restaurant> list2 = list.map((e) => e).toList();
    list2.sort((b, a) {
      return a.rating!.compareTo(b.rating!);
    });
    return list2;
  }

  List<Restaurant> searchItem(String value) {
    List<Restaurant> list3 = [];
    for (int i = 0; i < listfull.length; i++) {
      if (TiengViet.parse(listfull[i].title.toString().toLowerCase())
          .contains(TiengViet.parse(value.toLowerCase()))) {
        list3.add(listfull[i]);
      }
    }
    return list3;
  }
}
