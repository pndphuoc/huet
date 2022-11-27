import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Comment extends StatefulWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      ),
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                  "Bạn fan tên Phước đẹp trai quá !! <3",
                  style:
                  GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(width: 10,),
          IntrinsicWidth(child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_outline,
                  size: 15,),
                onPressed: (){},
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Text(
                "2446",
                style: GoogleFonts.readexPro(color: Colors.grey),
              )
            ],
          ),)
        ],
      ),
    );
  }
}
