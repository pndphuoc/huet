import 'package:flutter/material.dart';

class PostModel {
  String postID;
  String caption;
  int userID;
  String attractionID;
  List<String> medias;
  int likeCount;
  int commentCount;
  DateTime createDate;
  bool isDeleted;

  PostModel({required this.postID,required this.caption, required this.userID, required this.attractionID, required this.medias, required this.likeCount, required this.commentCount, required this.createDate, required this.isDeleted});

  Map<String, dynamic> toJson() => {
    'postID': postID,
    'caption': caption,
    'userID': userID,
    'attractionID': attractionID,
    'medias': medias,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'createDate': createDate,
    'isDeleted': false
  };
}