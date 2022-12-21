import 'package:hue_t/firebase_function/comment_function.dart';

class Comment {
  String id;
  String userID;
  String content;
  List<String> likedUsers;
  DateTime createDate;
  List<Comment>? replyComments;
  int? replyCount = 0;
  Comment({required this.id, required this.userID, required this.content, required this.likedUsers, required this.createDate, this.replyCount});
  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(id: json['id'], userID: json['userID'], content: json['content'], likedUsers: json['likedUsers'].cast<String>(), createDate: json['createDate'].toDate(), );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'content': content,
      'likedUsers': likedUsers,
      'createDate': createDate
    };
  }
}