

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:uuid/uuid.dart';
import '../constants/user_info.dart';

import '../model/social_network/post_model.dart';

Future<void> postComment(String content, String userID, String postID) async {
  final docPost = FirebaseFirestore.instance.collection('post').doc(postID);
  Comment cmt = Comment(id: const Uuid().v1(), userID: userID, content: content, likedUsers: [], createDate: DateTime.now());
  docPost.update({'comments': FieldValue.arrayUnion([cmt.toJson()])});
}

Future<PostModel> getPostContent(String postID) async {
  final doc = FirebaseFirestore.instance.collection('post').doc(postID);
  final post = await doc.get();
  return PostModel.fromJson(post.data()!);
}

Future<PostModel> displayUsersCommentFirst(String postID) async {
  PostModel post = await getPostContent(postID);
  List<Comment> comments = [];
  for(var e in post.comments) {
    if(e.userID == user!.uid) {
        comments.add(e);
        post.comments.remove(e);
    }
  }
  comments.sort((a, b) => a.createDate.compareTo(b.createDate),);
  post.comments = comments + post.comments;
  return post;
}

