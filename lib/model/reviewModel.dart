import 'dart:core';
class reviewModel {
  int id;
  int rating;
  String? review;
  List<String>? images;

  reviewModel({required this.id, required this.rating, this.review, this.images});
}