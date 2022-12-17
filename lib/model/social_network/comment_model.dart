class CommentModel {
  String id;
  String userId;
  String postId;
  String content;
  int likeCount;

  CommentModel({required this.id, required this.userId, required this.postId, required this.content, required this.likeCount});
}