import 'dart:core';
import 'locationModel.dart';
import 'reviewModel.dart';
import 'roomTypeModel.dart';
class hotelModel {
  int id;
  int accommondationType;
  String name;
  String address;
  location accommodationLocation;
  List<String> images;
  int price;
  double? rating;
  List<reviewModel>? reviews;
  List<roomTypeModel> types;
  double? distance;

  hotelModel({required this.id, required this.accommondationType, required this.name, required this.address, required this.accommodationLocation, required this.images, required this.price, this.rating, this.reviews, required this.types});
}