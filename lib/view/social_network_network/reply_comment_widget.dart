import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/colors.dart' as colors;
import '../../firebase_function/common_function.dart';
import '../../constants/user_info.dart' as user_info;

typedef void StringCallback();
typedef void CommentCallback(Comment value);

class ReplyCommentWidget extends StatefulWidget {
  const ReplyCommentWidget(
      {Key? key,
        required this.cmt,
        required this.postID, required this.callback, required this.cmtID, required this.selectCallback})
      : super(key: key);
  final Comment cmt;
  final String postID;
  final String cmtID;
  final StringCallback callback;
  final CommentCallback selectCallback;

  @override
  State<ReplyCommentWidget> createState() => _ReplyCommentWidgetState();
}

class _ReplyCommentWidgetState extends State<ReplyCommentWidget>
    with TickerProviderStateMixin {
  final GlobalKey _menuKey = GlobalKey();
  bool isLiked = false;
  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  int currentPos = 0;
  bool isHeartAnimating = false;
  late int likeCount;
  bool isSelecting =false;
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

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: const [
        PopupMenuItem<String>(
          value: 'del',
          child: Text('Delete')),
        PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit')),],
      elevation: 8.0,
    );
  }

  Future<void> _likeAndUnlikeComment() async {
    final doc = FirebaseFirestore.instance.collection('post').doc(widget.postID).collection('comments').doc(widget.cmtID).collection('replyComments').doc(widget.cmt.id);
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
          color: isSelecting == widget.cmt.id
              ? Colors.black12
              : colors.backgroundColor),
      padding: const EdgeInsets.only(left: 55, top: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
                width: 35,
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
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPressStart: (details) {
                    _showPopupMenu(details.globalPosition);
                  },
                /*  onLongPress: () {
                    dynamic state = _menuKey.currentState;
                    state.showButtonMenu();
                    //widget.selectCallback(widget.cmt);
                    setState(() {});
                  },*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "lalalalisa_m",
                        style: GoogleFonts.readexPro(
                            color: Colors.black, fontSize: 15),
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

                    ],
                  ),
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
    );
  }

  Widget buildReplyButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35),
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
}
