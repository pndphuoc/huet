import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'dart:convert' as convert;
import 'media_model.dart';

class PostModel {
  String postID;
  String? caption;
  int userID;
  String attractionID;
  List<Media> medias;
  List<String> likedUsers;
  List<Comment> comments;
  DateTime createDate;
  bool isDeleted;

  PostModel({required this.postID,this.caption, required this.userID, required this.attractionID, required this.medias, required this.likedUsers, required this.comments, required this.createDate, required this.isDeleted});

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
      'likedUsers': likedUsers,
      'comments': comments,
      'createDate': createDate,
      'isDeleted': false
    };
  }
  static PostModel fromJson(Map<String, dynamic> json) {
    List<Media> medias = [];
    for(var e in List.from(json['medias'])) {
      medias.add(Media.fromJson(e));
    }
    List<Comment> comments = [];
    for(var e in json['comments']){
      comments.add(Comment.fromJson(e));
    }
    return PostModel(
        postID: json['postID'],
        userID: json['userID'],
        caption: json['caption'],
        attractionID: json['attractionID'],
        medias: medias,
        likedUsers: List<String>.from(json['likedUsers']),
        comments: comments,
        createDate: json['createDate'].toDate(),
        isDeleted: json['isDeleted']);
  }

/*  static PostModel fromJson(Map<String, dynamic> json) {
    List<Media> medias = [];
    for(var e in List.from(json['medias'])) {
      medias.add(Media.fromJson(e));
    }
    return PostModel(
        postID: json['postID'], caption: json['caption'], userID: json['userID'], attractionID: json['attractionID'],
        medias:  medias,
        createDate: (json['createDate'] as Timestamp).toDate(), isDeleted: false, likedUsers: []);
  }*/
}