import 'dart:core';
import 'locationModel.dart';
import 'reviewModel.dart';
import 'roomTypeModel.dart';

class hotelModel {
  String id;
  int? accommondationType;
  String name;
  String address;
  location accommodationLocation;
  String? image;
  List images;
  int price;
  double? rating;
  List<reviewModel>? reviews;
  List<dynamic> types;
  double? distance;

  hotelModel(
      {required this.id,
      this.accommondationType,
      required this.name,
      required this.address,
      required this.accommodationLocation,
      this.image,
      required this.images,
      required this.price,
      this.rating,
      this.reviews,
      required this.types});
  factory hotelModel.fromJson(Map<String, dynamic> obj) {
    return hotelModel(
        id: obj['id'].toString(),
        name: obj['name'],
        address: "Thành Phố Huế",
        accommodationLocation: location(
            latitude: double.parse(
                obj['accommodationLocation']['latitude'].toString()),
            longitude: double.parse(
                obj['accommodationLocation']['longitude'].toString())),
        image: obj['imageUrl'],
        images: obj['imageUrls'],
        rating: double.parse(obj['starRating'].toString()),
        price: int.parse(obj['price'].toString()),
        types: obj['roomType']);
  }
}
