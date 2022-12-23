import 'package:hue_t/model/social_network/comment_model.dart';
import 'media_model.dart';
import '../../firebase_function/comment_function.dart';

class PostModel {
  String postID;
  String? caption;
  int userID;
  String attractionID;
  List<Media> medias;
  List<String> likedUsers;
  List<Comment>? comments;
  int? commentsCount;
  DateTime createDate;
  bool isDeleted;

  PostModel(
      {required this.postID,
      this.caption,
      required this.userID,
      required this.attractionID,
      required this.medias,
      required this.likedUsers,
       this.comments,
      required this.createDate,
      required this.isDeleted,
      this.commentsCount});

  Map<String, dynamic> toJson() {
    var mediaJson = [];
    for (int i = 0; i < medias.length; i++) {
      mediaJson.add(medias[i].toJson());
    }
    return {
      'postID': postID,
      'caption': caption,
      'userID': userID,
      'attractionID': attractionID,
      'medias': mediaJson,
      'likedUsers': likedUsers,
      'createDate': createDate,
      'isDeleted': false
    };
  }

  static Future<PostModel> fromJson(Map<String, dynamic> json) async {
    List<Media> medias = [];
    for (var e in List.from(json['medias'])) {
      medias.add(Media.fromJson(e));
    }
    /*List<Comment> comments = [];
    comments = await getAllComment(json['postID']);*/
/*    for(var e in json['comments']){
      comments.add(Comment.fromJson(e));
    }*/
    return PostModel(
        commentsCount: await getCommentsCount(json['postID']),
        postID: json['postID'],
        userID: json['userID'],
        caption: json['caption'],
        attractionID: json['attractionID'],
        medias: medias,
        likedUsers: List<String>.from(json['likedUsers']),
        //comments: comments,
        createDate: json['createDate'].toDate(),
        isDeleted: json['isDeleted']);
  }

/*  static PostModel fromJson(Map<String, dynamic> json) {
    List<Media> medias = [];
    for(var e in List.from(json['medias'])) {
      medias.add(Media.fromJson(e));
    }
    return PostModel(
        postID: json['postID'], caption: json['caption'], userID: json['userID'], attractionID: json['attractionID'],
        medias:  medias,
        createDate: (json['createDate'] as Timestamp).toDate(), isDeleted: false, likedUsers: []);
  }*/
}
