import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hue_t/api/foodstore/food_store_api.dart';
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:hue_t/model/favorite/favorite.dart';
import '../../constants/user_info.dart' as user_constants;

class FavoriteProvider extends ChangeNotifier {
  List<Favorite> listFavorite = [];

  Future<void> getAll(String userID) async {
    String apiURL = "${url.url}/api/favourite/$userID";
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newsListObject = jsonObject as List;
    listFavorite = newsListObject.map((e) {
      return Favorite.fromJson(e);
    }).toList();
    notifyListeners();
  }

  bool checkFavorite(String id) {
    for (int i = 0; i < listFavorite.length; i++) {
      if (listFavorite[i].id == id) {
        return true;
      }
    }
    return false;
  }

  Future<bool> addFavorite(String id, String name, String address, String image,
      int category, String userID) async {
    final response = await http.post(
      Uri.parse('${url.url}/api/favourite/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "id": id,
        "name": name,
        "address": address,
        "image": image,
        "category": category,
        "userID": userID
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // var jsonObject = jsonDecode(response.body);
      getAll(user_constants.user!.uid);
      notifyListeners();
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.

      return false;
    }
  }

  Future<bool> deleteFavorite(String id, int category, String userID) async {
    final response = await http.delete(
      Uri.parse('${url.url}/api/favourite/delete/$userID/$category/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // var jsonObject = jsonDecode(response.body);
      getAll(user_constants.user!.uid);
      notifyListeners();
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.

      return false;
    }
  }
}
