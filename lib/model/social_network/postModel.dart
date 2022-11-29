import 'package:flutter/material.dart';

class PostModel {
  int postID;
  String content;
  int userID;
  int placeID;
  List<String> photos;
  int likeCount;
  int commentCount;
  DateTime createDate;
  bool isDeleted;

  PostModel({required this.postID,required this.content, required this.userID, required this.placeID, required this.photos, required this.likeCount, required this.commentCount, required this.createDate, required this.isDeleted});
}