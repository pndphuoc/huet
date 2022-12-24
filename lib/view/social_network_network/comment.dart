import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'package:hue_t/view/social_network_network/reply_comment_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../firebase_function/comment_function.dart';
import '../../firebase_function/common_function.dart';
import '../../constants/user_info.dart' as user_info;

typedef void StringCallback();
typedef void deleteCallback(Comment value);

class CommentWidget extends StatefulWidget {
  const CommentWidget(
      {Key? key,
      required this.cmt,
      required this.isSelecting,
      required this.postID,
      required this.callback, required this.delCallback,})
      : super(key: key);
  final Comment cmt;
  final String isSelecting;
  final String postID;
  final StringCallback callback;
  final deleteCallback delCallback;
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
  bool isReadAllReplyComments = false;
  Comment? selectedItem;
  bool isSelectingItem = false;
  bool isLoadingReplyComments = false;

  @override
  void dispose() {
    //_heartController.dispose();
    super.dispose();
  }

  List<Comment> replyComments = [];

  _getReplyComments() async {
    replyComments = await getReplyComments(widget.postID, widget.cmt.id);
  }

  _likeStatus() async {
    if (widget.cmt.likedUsers.contains(user_info.user!.uid)) {
      setState(() {
        isLiked = true;
      });
    }
  }

  Future<void> _likeAndUnlikeComment() async {
    final doc = FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postID)
        .collection('comments')
        .doc(widget.cmt.id);
    if (!isLiked) {
      doc.update({
        'likedUsers': FieldValue.arrayUnion([user_info.user!.uid])
      });
      likeCount += 1;
    } else {
      doc.update({
        'likedUsers': FieldValue.arrayRemove([user_info.user!.uid])
      });
      likeCount -= 1;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _likeStatus();
    _getReplyComments();
    likeCount = widget.cmt.likedUsers.length;
  }
 /* _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
          onTap: () async{
            await deleteComment(widget.cmt, widget.postID);
            Fluttertoast.showToast(
                msg: "Deleted 1 comment",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            widget.delCallback(widget.cmt);
          },
            value: 'del',
            child: Text('Delete')),
        PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit')),],
      elevation: 8.0,
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPressStart: (details) {
            //_showPopupMenu(details.globalPosition);
           /* setState(() {
              isSelectingItem = true;
            });*/
          },

/*            onLongPress: () {
            //widget.selectCallback(widget.cmt, false, widget.cmt.id);

            //setState(() {});
          },*/
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
                color: isSelectingItem
                    ? Colors.black12
                    : colors.backgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            style: GoogleFonts.montserrat(
                                color: Colors.black, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          buildDateFormat(
                              widget.cmt.createDate, Colors.grey, 10),
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
                buildReplyButton(context),
              ],
            ),
          ),
        ),
        widget.cmt.replyCount! > 0
            ? isLoadingReplyComments
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: colors.primaryColor, size: 15),
                  )
                : buildReadReplyComment(context, widget.postID, widget.cmt.id,
                    widget.cmt.replyCount!)
            : Container(),
        if(isReadAllReplyComments)
        ...replyComments.map((e) => ReplyCommentWidget(
              cmt: e,
              postID: widget.postID,
              parentCmtID: widget.cmt.id,
            ))
      ],
    );
  }

  Widget buildReplyButton(BuildContext context) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(left: 45),
      child: TextButton(
          onPressed: () {
            widget.callback();
          },
          style: TextButton.styleFrom(
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
              alignment: Alignment.center),
          child: Text(
            "Reply",
            style: GoogleFonts.readexPro(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
          )),
    );
  }

  Widget buildReadReplyComment(BuildContext context, String postID,
      String cmtID, int replyCommentsCount) {
    return Container(
      margin: const EdgeInsets.only(left: 55),
      child: TextButton(
          onPressed: () async {
            if (!isReadAllReplyComments) {
              setState(() {
                isLoadingReplyComments = true;
              });
              replyComments =
                  await getReplyComments(widget.postID, widget.cmt.id);
            } else {
              replyComments = [];
            }
            setState(() {
              isLoadingReplyComments = false;
              isReadAllReplyComments = !isReadAllReplyComments;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: !isReadAllReplyComments
              ? Text(
                  "----- Read $replyCommentsCount reply comments",
                  style: GoogleFonts.readexPro(color: Colors.grey),
                )
              : Text(
                  "----- Hide $replyCommentsCount reply comments",
                  style: GoogleFonts.readexPro(color: Colors.grey),
                )),
    );
  }
}
