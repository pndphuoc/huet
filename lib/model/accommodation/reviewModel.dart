import 'dart:core';

class reviewModel {
  int id;
  int userId;
  int rating;
  String? review;
  List<String>? images;
  DateTime reviewDate;

  reviewModel(
      {required this.id,
      required this.userId,
      required this.rating,
      this.review,
      this.images,
      required this.reviewDate});
}
