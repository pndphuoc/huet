import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/constants/user_info.dart';

class PostingCommentWidget extends StatefulWidget {
  const PostingCommentWidget({Key? key, required this.content})
      : super(key: key);
  final String content;

  @override
  State<PostingCommentWidget> createState() => _PostingCommentWidgetState();
}

class _PostingCommentWidgetState extends State<PostingCommentWidget>
    with TickerProviderStateMixin {
  int currentPos = 0;
  bool isHeartAnimating = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
            width: 45,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user!.photoURL),
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
                      user!.name,
                      style: GoogleFonts.readexPro(
                          color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.content,
                  style:
                      GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                //buildDateFormat(widget.cmt.createDate, Colors.grey, 10),
                Text(
                  "Posting...",
                  style:
                      GoogleFonts.readexPro(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
