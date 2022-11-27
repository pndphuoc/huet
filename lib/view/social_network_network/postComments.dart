import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Comments",
          style: GoogleFonts.readexPro(color: Colors.black),
        ),
        backgroundColor: colors.backgroundColor,
        elevation: 0,
      ),
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [contentBlock(context), commentBlock(context)],
          ),
        ),
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  contentBlock(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5
          )
        )
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/socialNetwork/jennieAvatar.png",
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "jennierubyjane",
                    style: GoogleFonts.readexPro(
                        color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${daysBetween(widget.post.createDate, DateTime.now())} days before",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.post.content,
                style:
                    GoogleFonts.montserrat(color: Colors.black, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }

  commentBlock(BuildContext context) {
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
                    Text(
                      "${daysBetween(widget.post.createDate, DateTime.now())} days before",
                      style: GoogleFonts.readexPro(color: Colors.grey),
                    )
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
