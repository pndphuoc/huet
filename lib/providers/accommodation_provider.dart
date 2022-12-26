import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:hue_t/model/accommodation/accommodationModel.dart';

class AccomodationProvider extends ChangeNotifier {
  bool isloading = true;
  List<hotelModel> list = [];
  List<hotelModel> listFilter = [];
  List<hotelModel> listHotel = [];
  List<hotelModel> listResort = [];
  List<hotelModel> listHomestays = [];
  List<hotelModel> listSearch = [];

  Future<void> getAll() async {
    String apiURL = "${url.url}/api/hotel";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    list = newsListObject.map((e) {
      return hotelModel.fromJson(e);
    }).toList();
    notifyListeners();
  }

  Future<List<hotelModel>> filter(String id, int limit) async {
    String apiURL = "${url.url}/api/hotel/filterhotel/$id/$limit";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listFilter = newsListObject.map((e) {
      return hotelModel.fromJson(e);
    }).toList();
    notifyListeners();
    return listFilter;
  }

  Future<void> searchItem(String value) async {
    listSearch = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].name.toString().toLowerCase().contains(value.toLowerCase())) {
        listSearch.add(list[i]);
        notifyListeners();
      }
    }
  }
}
