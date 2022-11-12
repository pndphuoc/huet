import 'dart:core';
import 'reviewModel.dart';
import 'roomTypeModel.dart';
class hotelModel {
  int id;
  String name;
  String address;
  String? location;
  List<String> images;
  int price;
  double? rating;
  List<reviewModel>? reviews;
  List<roomTypeModel> types;

  hotelModel({required this.id, required this.name, required this.address, this.location, required this.images, required this.price, this.rating, this.reviews, required this.types});
}