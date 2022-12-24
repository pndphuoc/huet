

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'package:hue_t/view/social_network_network/post_comments.dart';
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
 /* FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(doc.id).collection('replyComments').doc().set({});
  final defaultDoc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(doc.id).collection('replyComments').get();
  //delete default when create replyComments collection
  FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(doc.id).collection('replyComments').doc(defaultDoc.docs.first.id).delete();
*/}

Future<int> getCommentsCount(String postID) async {
  final doc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').count().get();
  return doc.count;
}

Future<int> getReplyCommentCount(String postID, String cmtID) async {
  final doc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(cmtID).collection('replyComments').count().get();
  print("reply count $cmtID ${doc.count}");
  return doc.count;
}

Future<List<Comment>> getTopComment(String postID, int commentLimit) async {
  final doc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').limit(commentLimit).get();
  final listDocComment = doc.docs;
  lastComment = listDocComment.last;
  List<Comment> commentList = [];
  for(var e in listDocComment) {
    commentList.add(Comment.fromJson(e.data()));
    //final docsLen = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(e.id).collection('replyComments').get();
    commentList.last.replyCount = await getReplyCommentCount(postID, e.id);
  }
  return commentList;
}

QueryDocumentSnapshot? lastComment;

Future<List<Comment>> getMoreComments(String postID, int commentLimit, ) async {
  final doc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').startAfterDocument(lastComment!).limit(commentLimit).get();
  List<Comment> commentList = [];
  for(var e in doc.docs) {
    commentList.add(Comment.fromJson(e.data()));
  }
  return commentList;
}

Future<PostModel> getPostContent(String postID, int commentLimit) async {
  final doc = FirebaseFirestore.instance.collection('post').doc(postID);
  final post = await doc.get();
  PostModel postContent = await PostModel.fromJson(post.data()!);
  postContent.comments = await getTopComment(postContent.postID, commentLimit);
  return postContent;
}

Future<PostModel> displayUsersCommentFirst(String postID, int commentLimit) async {
  PostModel post = await getPostContent(postID, commentLimit);
  List<Comment> comments = [];
  for(var e in post.comments!) {
    if(e.userID == user!.uid) {
        comments.add(e);
        post.comments!.remove(e);
    }
  }
  comments.sort((a, b) => a.createDate.compareTo(b.createDate),);
  post.comments = comments + post.comments!;
  return post;
}

Future<void> deleteComment(Comment cmt, String postID) async {
  final docPost = FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(cmt.id);
  await docPost.delete();
}

Future<void> deleteReplyComment(Comment cmt, String postID,String cmtID) async {
  final docPost = FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(cmtID).collection('replyComments').doc(cmt.id);
  await docPost.delete();
}

Future<void> postReplyComment(String content, String userID, String postID, String cmtID) async {
  final doc = FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(cmtID).collection('replyComments').doc();
  Comment cmt = Comment(id: doc.id, userID: userID, content: content, likedUsers: [], createDate: DateTime.now());
  doc.set(cmt.toJson());
}

Future<List<Comment>> getReplyComments(String postID, String cmtID) async {
  final doc = await FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(cmtID).collection('replyComments').get();
  final listDocComment = doc.docs;
  //print(listDocComment.first.data());

  List<Comment> replyCommentList = [];
  if(listDocComment.isNotEmpty) {
    for(var e in listDocComment) {
      replyCommentList.add(Comment.fromJson(e.data()));
    }
  }
  replyCommentList.sort((a, b) => a.createDate.compareTo(b.createDate),);
  return replyCommentList;
}


Future<List<Comment>> getAllReplyCommentOfUser(String userID, String postID, String cmtID) async {

  Query snapshot = FirebaseFirestore.instance.collection('post').doc(postID).collection('comments').doc(cmtID).collection('replyComments').where('userID', isEqualTo: userID);
  //final docs = snapshot.docs.where((element) => (element.data() as Map<String, dynamic>)["userID"] == userID);
  final docs = await snapshot.get();
  final replyComments = docs.docs;
  List<Comment> replyCommentOfUser = [];
  for(var e in replyComments) {
    replyCommentOfUser.add(Comment.fromJson(e.data() as Map<String, dynamic>));
  }
  return replyCommentOfUser;
}

bool likeStatus(List json, String userID) {
  if(json.contains(userID))
    {
      return true;
    }
  return false;
}

Future<void> likeAndUnlikeComment(Comment cmt, String postID) async {
  final doc = FirebaseFirestore.instance
      .collection('post')
      .doc(postID)
      .collection('comments')
      .doc(cmt.id);
  if (!cmt.isLiked!) {
    doc.update({
      'likedUsers': FieldValue.arrayUnion([user!.uid])
    });
  } else {
    doc.update({
      'likedUsers': FieldValue.arrayRemove([user!.uid])
    });
  }
}

Future<void> likeAndUnlikeReplyComment(Comment cmt, String postID, String parentCmtID) async {
  final doc = FirebaseFirestore.instance
      .collection('post')
      .doc(postID)
      .collection('comments')
      .doc(parentCmtID).collection('replyComments').doc(cmt.id);
  if (!cmt.isLiked!) {
    doc.update({
      'likedUsers': FieldValue.arrayUnion([user!.uid])
    });
  } else {
    doc.update({
      'likedUsers': FieldValue.arrayRemove([user!.uid])
    });
  }
}
