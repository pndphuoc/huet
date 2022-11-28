import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/model/social_network/comment_model.dart';

class Comment extends StatefulWidget {
  const Comment({Key? key, required this.cmt}) : super(key: key);
  final CommentModel cmt;
  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> with TickerProviderStateMixin{
  bool isLiked = false;

  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _heartController,
    curve: Curves.fastOutSlowIn,
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
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/socialNetwork/lisaAvatar.png",
              ),
            ),
          ),
          SizedBox(
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
                    SizedBox(
                      width: 10,
                    ),
                    /*Text(
                      "${daysBetween(widget.post.createDate, DateTime.now())} days before",
                      style: GoogleFonts.readexPro(color: Colors.grey),
                    )*/
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.cmt.content,
                  style:
                  GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(width: 10,),
          IntrinsicWidth(child: Column(
            children: [
              HeartAnimation(
                onEnd: () => setState(() => isHeartAnimating = false),
                duration: Duration(milliseconds: 500),
                isAnimating: isHeartAnimating,
                child: IconButton(
                  icon: isLiked?Icon(Icons.favorite,
                    size: 15, color: Colors.red,): Icon(Icons.favorite_outline,
                    size: 15,),
                  onPressed: (){
                    setState(() {
                      isLiked = !isLiked;
                      isHeartAnimating = !isHeartAnimating;
                    });
                  },
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
              Text(
                widget.cmt.likeCount.toString(),
                style: GoogleFonts.readexPro(color: Colors.grey),
              )
            ],
          ),)
        ],
      ),
    );
  }
}
