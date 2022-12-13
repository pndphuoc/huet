import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../model/social_network/postModel.dart';

class PostsProvider extends ChangeNotifier {
  List<PostModel> list = [];

  static Stream<List<PostModel>> readPosts() => FirebaseFirestore.instance.collection("post")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => PostModel.fromJson(doc.data()) ).toList());
}