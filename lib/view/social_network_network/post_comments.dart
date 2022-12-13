import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/comment.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

List<CommentModel> commentList = [
  CommentModel(
      id: "1", userId: "1", postId: "1", content: "abcsdf", likeCount: 6999),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431),
  CommentModel(
      id: "2",
      userId: "2",
      postId: "1",
      content: "Phuoc dep trai",
      likeCount: 2431)
];

class _PostCommentsPageState extends State<PostCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            "Comments",
            style: GoogleFonts.readexPro(color: Colors.black),
          ),
          backgroundColor: colors.backgroundColor,
          elevation: 0,
        ),
        backgroundColor: colors.backgroundColor,
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  contentBlock(context),
                  ...commentList.map((e) => Comment(cmt: e)),
                  const SizedBox(height: 80, )
                ],
              ),
            ),
            commentBlock(context)
          ]),
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
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 45,
            width: 45,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/socialNetwork/jennieAvatar.png",
              ),
            ),
          ),
          const SizedBox(
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
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${daysBetween(widget.post.createDate, DateTime.now())} days before",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.post.caption!,
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
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: colors.SN_postBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/socialNetwork/avatar.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(child: TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      border: InputBorder.none,
                    hintText: "Write a comment"
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send_rounded,
                    color: colors.primaryColor,
                    size: 30,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                )
              ],
            ),
          ),
        ));
  }
}
