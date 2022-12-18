

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hue_t/model/social_network/comment_model.dart';

Future _postComment(String content, String userID, String postID) async {
  final docPost = FirebaseFirestore.instance.collection('post').doc(postID);
  Comment cmt = Comment(id: Uuid()., userID: userID, content: content, likedUsers: []);
  docPost.update({'comments': FieldValue.arrayUnion(Comment.)})
}