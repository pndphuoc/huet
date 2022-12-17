import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hue_t/constants/host_url.dart' as url;

class UserProvider extends ChangeNotifier {
  bool isRegister = true;
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
}
