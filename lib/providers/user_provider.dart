import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:hue_t/model/user/user.dart';
import '../../constants/user_info.dart' as userConstant;

class UserProvider extends ChangeNotifier {
  bool isRegister = true;
  bool isLogin = true;
  bool isGoogle = false;
  bool isUpdate = false;

  Future<bool> createUser(String name, String email, String password,
      String image, String phone, bool isGoogle) async {
    final response = await http.post(
      Uri.parse('${url.url}/api/user/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "email": email,
        "password": password,
        "image": image,
        "phone": phone,
        "isGoogle": isGoogle
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      userConstant.user = User(
          name: jsonObject[0]['name'],
          mail: jsonObject[0]['email'],
          photoURL: jsonObject[0]['image'],
          uid: jsonObject[0]['_id'],
          password: jsonObject[0]['password'],
          phoneNumber: jsonObject[0]['phone'],
          isGoogle: jsonObject[0]['isGoogle']);

      isRegister = true;
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      isRegister = false;
      return false;
    }
  }

  Future<bool> updateUser(String name, String email, String password,
      String image, String phone, bool? isGoogle) async {
    final response = await http.put(
      Uri.parse('${url.url}/api/user/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "email": email,
        "password": password,
        "image": image,
        "phone": phone,
        "isGoogle": isGoogle
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      userConstant.user = User(
          name: jsonObject['name'],
          mail: jsonObject['email'],
          photoURL: jsonObject['image'],
          uid: jsonObject['_id'],
          password: jsonObject['password'],
          phoneNumber: jsonObject['phone'],
          isGoogle: jsonObject['isGoogle']);
      isUpdate = true;
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      isUpdate = false;
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
          photoURL: jsonObject[0]['image'],
          uid: jsonObject[0]['_id'],
          password: jsonObject[0]['password'],
          phoneNumber: jsonObject[0]['phone'],
          isGoogle: jsonObject[0]['isGoogle']);
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

  Future<bool> checkEmail(String email) async {
    final response = await http.post(
      Uri.parse('${url.url}/api/user/checkemail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      userConstant.user = User(
          name: jsonObject[0]['name'],
          mail: jsonObject[0]['email'],
          photoURL: jsonObject[0]['image'],
          uid: jsonObject[0]['_id'],
          password: jsonObject[0]['password'],
          phoneNumber: jsonObject[0]['phone'],
          isGoogle: jsonObject[0]['isGoogle']);
      isGoogle = true;
      notifyListeners();
      return true;
    } else if (response.statusCode == 403) {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      isGoogle = false;
      notifyListeners();
    } else {}
    return false;
  }

  Future<User> getUser(String userID) async {
    final response = await http.get(
      Uri.parse('${url.url}/api/user/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      return User(
          name: jsonObject['name'],
          mail: jsonObject['email'],
          photoURL: jsonObject['image'],
          uid: jsonObject['_id'],
          password: jsonObject['password'],
          phoneNumber: jsonObject['phone'],
          isGoogle: jsonObject['isGoogle']);
    } else {
      throw Exception("User invalid");
    }
  }
}
