

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:uuid/uuid.dart';

Future postComment(String content, String userID, String postID) async {
  final docPost = FirebaseFirestore.instance.collection('post').doc(postID);
  Comment cmt = Comment(id: const Uuid().v1(), userID: userID, content: content, likedUsers: []);
  docPost.update({'comments': FieldValue.arrayUnion([cmt.toJson()])});
}

Future<PostModel> (String postID) async {
  final doc = FirebaseFirestore.instance.collection('post').doc(postID);
  final post = await doc.get();
  return PostModel.fromJson(post.data()!);
}