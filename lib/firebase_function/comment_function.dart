

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:uuid/uuid.dart';
import '../constants/user_info.dart';

import '../model/social_network/post_model.dart';

Future<void> postComment(String content, String userID, String postID) async {
/*  final docPost = FirebaseFirestore.instance.collection('post').doc(postID);
  final docComment = FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc();
  Comment cmt = Comment(id: docComment.id, userID: userID, content: content, likedUsers: [], createDate: DateTime.now());
  await docPost.update({'comments': FieldValue.arrayUnion([cmt.toJson()])});*/

  final doc = FirebaseFirestore.instance.collection('post').doc(postID).collection('comments')
      .doc();
  Comment cmt = Comment(id: doc.id, userID: userID, content: content, likedUsers: [], createDate: DateTime.now());
  doc.set(cmt.toJson());
}

Future<List<Comment>> getAllComment(String postID) async {
  final doc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').get();
  final listDocComment = doc.docs;
  //print(listDocComment.first.data());
  List<Comment> commentList = [];
  for(var e in listDocComment) {
    commentList.add(Comment.fromJson(e.data()));
  }
  return commentList;
}

Future<PostModel> getPostContent(String postID) async {
  final doc = FirebaseFirestore.instance.collection('post').doc(postID);
  final post = await doc.get();
  PostModel postContent = await PostModel.fromJson(post.data()!);
  postContent.comments = await getAllComment(postContent.postID);
  return postContent;
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

Future<void> deleteComment(Comment cmt, String postID) async {
  final docPost = FirebaseFirestore.instance.collection('post').doc(postID);
  await docPost.update({'comments': FieldValue.arrayRemove([cmt.toJson()])});
}

