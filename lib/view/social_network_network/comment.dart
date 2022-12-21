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
typedef void StringCallback();
class CommentWidget extends StatefulWidget {
  const CommentWidget(
      {Key? key,
      required this.cmt,
      required this.isSelecting,
      required this.postID, required this.callback})
      : super(key: key);
  final Comment cmt;
  final String isSelecting;
  final String postID;
  final StringCallback callback;

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
    //_heartController.dispose();
    super.dispose();
  }

  _likeStatus() async {
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
                  height: 5,
                ),
                buildDateFormat(widget.cmt.createDate, Colors.grey, 10),
                buildReplyButton(context),
                widget.cmt.replyComments!.isNotEmpty ? buildReadReplyComment(context, widget.postID, widget.cmt.id, widget.cmt.replyComments!.length) : Container()
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

  Widget buildReplyButton(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextButton(onPressed: (){
        widget.callback();
      },
          style: TextButton.styleFrom(
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashFactory: NoSplash.splashFactory,
            alignment: Alignment.center
          ),
          child: Text("Reply", style: GoogleFonts.readexPro(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),)
      ),
    );
  }

  Widget buildReadReplyComment(BuildContext context, String postID, String cmtID, int replyCommentsCount) {
    return TextButton(
        onPressed: (){},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text("----- Read $replyCommentsCount reply comments", style: GoogleFonts.readexPro(color: Colors.grey),));
  }
}
