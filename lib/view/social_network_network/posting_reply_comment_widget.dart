import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostingReplyCommentWidget extends StatefulWidget {
  const PostingReplyCommentWidget({Key? key, required this.content})
      : super(key: key);
  final String content;

  @override
  State<PostingReplyCommentWidget> createState() =>
      _PostingReplyCommentWidgetState();
}

class _PostingReplyCommentWidgetState extends State<PostingReplyCommentWidget>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 55),
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
            width: 30,
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
