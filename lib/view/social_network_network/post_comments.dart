import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/view/social_network_network/comment.dart';
import 'package:hue_t/view/social_network_network/posting_comment_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../firebase_function/comment_function.dart';
import '../../constants/user_info.dart' as user_info;
import '../../firebase_function/comment_function.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage({Key? key, required this.postID}) : super(key: key);
  final String postID;

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  final ScrollController _controller = ScrollController();

  late String commentContent;
  final commentController = TextEditingController();
  late PostModel post;
  bool isLoading = true;
  bool isPostingComment = false;
  bool isSelectingItem = false;
  _getPostContent() async {
    //post = await displayUsersCommentFirst(widget.postID);
    post = await getPostContent(widget.postID);

    //display user's comment first
    List<Comment> myComments = [];
    post.comments.toList().forEach((element) {
      if(element.userID == user_info.user!.uid) {
        myComments.add(element);
        post.comments.remove(element);
      }
    });
    myComments.sort((a, b) => b.createDate.compareTo(a.createDate),);
    post.comments = myComments + post.comments;

    setState(() {
      isLoading = false;
    });
  }

  void _scrollUp() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    _getPostContent();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: !isSelectingItem ? appBar(context) : appBarDeleteComment(context),
        backgroundColor: colors.backgroundColor,
        body: isLoading ? Center(child: LoadingAnimationWidget.discreteCircle(color: colors.primaryColor, size: 30),) : SafeArea(
          child: Stack(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: [
                    contentBlock(context),
                    isPostingComment ? postingCommentBlock(context, commentContent) : Container(),
                    ...post.comments.map((e) => GestureDetector(
                        onLongPress: (){
                          setState(() {
                            isSelectingItem = true;
                          });
                        },
                        child: CommentWidget(cmt: e, isSelecting: isSelectingItem ? true : false,))),
                    const SizedBox(height: 80,)
                  ],
                ),
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
                    "${daysBetween(post.createDate, DateTime.now())} days before",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                post.caption!,
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
                const SizedBox(
                  height: 45,
                  width: 45,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/socialNetwork/avatar.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: TextField(
                  controller: commentController,
                  autofocus: true,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      border: InputBorder.none,
                    hintText: "Write a comment"
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () async {
                    if(commentController.value.text.isNotEmpty) {
                      _scrollUp();
                      FocusScope.of(context).requestFocus(FocusNode());
                      commentContent = commentController.text;
                      isPostingComment = true;
                      setState(() {});
                      commentController.clear();
                      await postComment(commentContent, user_info.user!.uid, post.postID);
                      await _getPostContent();
                      isPostingComment = false;
                      setState(() {});
                    }
                  },
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

  Widget postingCommentBlock(BuildContext context, String content) {
    return AnimatedContainer(duration: const Duration(milliseconds: 5000),
      color: isPostingComment ? Colors.black12 : colors.backgroundColor,
      child: PostingCommentWidget(content: content),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        "Comments",
        style: GoogleFonts.readexPro(color: Colors.black),
      ),
      backgroundColor: colors.backgroundColor,
      elevation: 0,
    );
  }

  AppBar appBarDeleteComment(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: (){
          setState(() {
            isSelectingItem = false;
          });
        },
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        "1 item selected",
        style: GoogleFonts.readexPro(color: Colors.black),
      ),
      backgroundColor: colors.backgroundColor,
      elevation: 0,
    );
  }
}
