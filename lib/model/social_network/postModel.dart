import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  static PostModel fromJson(Map<String, dynamic> json) {
    List<String> medias = [];
    List.from(json['medias']).forEach((element) {
      medias.add(element);
    });
    return PostModel(
        postID: json['postID'].toString(), caption: json['caption'].toString(), userID: json['userID'], attractionID: json['attractionID'],
        medias: medias, likeCount: json['likeCount'], commentCount: json['commentCount'],
        createDate: (json['createDate'] as Timestamp).toDate(), isDeleted: false);
  }
}