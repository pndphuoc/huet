import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import '../../firebase_function/common_function.dart';
import '../../constants/user_info.dart' as user_info;

class CommentWidget extends StatefulWidget {
  const CommentWidget(
      {Key? key,
      required this.cmt,
      required this.isSelecting,
      required this.postID})
      : super(key: key);
  final Comment cmt;
  final String isSelecting;
  final String postID;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
    with TickerProviderStateMixin {
  bool isLiked = false;

  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  int currentPos = 0;
  bool isHeartAnimating = false;
  late int likeCount;

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  _likeStatus() async {
    /* await FirebaseFirestore.instance.collection('post').doc(widget.postID).get().then((doc) {
      final comment = Comment.fromJson(List.from(doc.data()!["comments"]).where((element) => element["id"] == widget.cmt.id).toList()[0]);
      if(comment.likedUsers.contains(user_info.user!.uid)) {
        setState(() {
          isLiked = true;
        });
      }
    });*/
    if (widget.cmt.likedUsers.contains(user_info.user!.uid)) {
      setState(() {
        isLiked = true;
      });
    }
  }

  Future<void> _likeAndUnlikeComment() async {
    final doc = FirebaseFirestore.instance.collection('post').doc(widget.postID).collection('comments').doc(widget.cmt.id);
    if(!isLiked) {
      doc.update({'likedUsers': FieldValue.arrayUnion([user_info.user!.uid])});
      likeCount+=1;
    }
    else
      {
        doc.update({'likedUsers': FieldValue.arrayRemove([user_info.user!.uid])});
        likeCount-=1;
      }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _likeStatus();
    likeCount = widget.cmt.likedUsers.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.isSelecting == widget.cmt.id
              ? Colors.black12
              : colors.backgroundColor),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 45,
            width: 45,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/socialNetwork/lisaAvatar.png",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "lalalalisa_m",
                      style: GoogleFonts.readexPro(
                          color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    /*Text(
                      "${daysBetween(widget.post.createDate, DateTime.now())} days before",
                      style: GoogleFonts.readexPro(color: Colors.grey),
                    )*/
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.cmt.content,
                  style:
                      GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildDateFormat(widget.cmt.createDate, Colors.grey, 10),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IntrinsicWidth(
            child: Column(
              children: [
                HeartAnimation(
                  isAnimating: isHeartAnimating, ////
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        _likeAndUnlikeComment();
                        isLiked = !isLiked;
                        isHeartAnimating = !isHeartAnimating;
                        _heartController.forward();
                      });
                    },
                    icon: isLiked
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                            size: 15,
                          )
                        : const Icon(
                            Icons.favorite_outline_rounded,
                            size: 15,
                          ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Text(
                  likeCount.toString(),
                  style: GoogleFonts.readexPro(color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
