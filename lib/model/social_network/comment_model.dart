class Comment {
  String id;
  String userID;
  String content;
  List<String> likedUsers;

  Comment({required this.id, required this.userID, required this.content, required this.likedUsers});

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(id: json['id'], userID: json['userID'], content: json['content'], likedUsers: json['likedUsers'].cast<String>());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': id,
      'content': content,
      'likedUsers': likedUsers
    };
  }
}