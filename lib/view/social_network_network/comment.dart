import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/colors.dart' as colors;
import '../../firebase_function/common_function.dart';


class CommentWidget extends StatefulWidget {
  const CommentWidget({Key? key, required this.cmt, required this.isSelecting}) : super(key: key);
  final Comment cmt;
  final bool isSelecting;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> with TickerProviderStateMixin{
  bool isLiked = false;

  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  int currentPos = 0;
  bool isHeartAnimating = false;
  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelecting ? Colors.black12 : colors.backgroundColor
      ),
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
                const SizedBox(height: 10,),
                buildDateFormat(widget.cmt.createDate, Colors.grey, 10),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10,),
          IntrinsicWidth(child: Column(
            children: [
              HeartAnimation(
                isAnimating: isHeartAnimating, ////
                child: IconButton(
                  onPressed: () {
                    setState(() {
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
                widget.cmt.likedUsers.length.toString(),
                style: GoogleFonts.readexPro(color: Colors.grey),
              )
            ],
          ),),
        ],
      ),
    );
  }
}
