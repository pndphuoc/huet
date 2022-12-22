import 'package:hue_t/firebase_function/comment_function.dart';
import '../../constants/user_info.dart' as user_info;
class Comment {
  String id;
  String userID;
  String content;
  List<String> likedUsers;
  DateTime createDate;
  List<Comment>? replyComments;
  int? replyCount = 0;
  int? likeCount;
  bool? isLiked;
  Comment({required this.id, required this.userID, required this.content, required this.likedUsers, required this.createDate, this.replyCount, this.isLiked, this.likeCount});
  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(id: json['id'],
        userID: json['userID'],
        content: json['content'],
        likedUsers: json['likedUsers'].cast<String>(),
        createDate: json['createDate'].toDate(),
        isLiked: likeStatus(json['likedUsers'],
        user_info.user!.uid), likeCount: json['likedUsers'].cast<String>().length);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'content': content,
      'likedUsers': likedUsers,
      'createDate': createDate,
    };
  }
}

