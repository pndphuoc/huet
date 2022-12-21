import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:hue_t/model/user/user.dart';
import '../../constants/user_info.dart' as userConstant;

class UserProvider extends ChangeNotifier {
  bool isRegister = true;
  bool isLogin = true;

  Future<bool> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${url.url}/api/user/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "email": email,
        "password": password,
        "image": "",
        "phone": ""
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      isRegister = true;
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      isRegister = false;
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${url.url}/api/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      userConstant.user = User(
          name: jsonObject[0]['name'],
          mail: jsonObject[0]['email'],
          photoURL:
              'https://i.ex-cdn.com/mgn.vn/files/content/2021/06/25/pp4-1724.jpg',
          uid: jsonObject[0]['_id']);
      isLogin = true;
      return true;
    } else if (response.statusCode == 403) {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      isRegister = false;
    } else {
      isRegister = false;
    }
    return false;
  }
}
