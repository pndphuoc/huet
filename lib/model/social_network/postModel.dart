import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'media_model.dart';

class PostModel {
  String postID;
  String? caption;
  int userID;
  String attractionID;
  List<Media> medias;
  int likeCount;
  int commentCount;
  DateTime createDate;
  bool isDeleted;

  PostModel({required this.postID,this.caption, required this.userID, required this.attractionID, required this.medias, required this.likeCount, required this.commentCount, required this.createDate, required this.isDeleted});

  Map<String, dynamic> toJson() {
    var mediaJson = [];
    for(int i =0; i< medias.length; i++) {
      mediaJson.add(medias[i].toJson());
    }
    return {
      'postID': postID,
      'caption': caption,
      'userID': userID,
      'attractionID': attractionID,
      'medias': mediaJson,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createDate': createDate,
      'isDeleted': false
    };
  }

  static PostModel fromJson(Map<String, dynamic> json) {
    List<Media> medias = [];
    for(var e in List.from(json['medias'])) {
      medias.add(Media.fromJson(e));
    }
    return PostModel(
        postID: json['postID'], caption: json['caption'], userID: json['userID'], attractionID: json['attractionID'],
        medias:  medias, likeCount: json['likeCount'], commentCount: json['commentCount'],
        createDate: (json['createDate'] as Timestamp).toDate(), isDeleted: false);
  }
}