import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/view/social_network_network/comment.dart';
import 'package:hue_t/view/social_network_network/posting_comment_widget.dart';
import 'package:hue_t/view/social_network_network/posting_reply_comment_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oktoast/oktoast.dart';
import '../../firebase_function/comment_function.dart';
import '../../constants/user_info.dart' as user_info;
import '../../firebase_function/comment_function.dart';
import '../../firebase_function/comment_function.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage({Key? key, required this.postID}) : super(key: key);
  final String postID;

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  final ScrollController _controller = ScrollController();
  late AutoScrollController _commentScrollController;
  late String commentContent;
  final commentController = TextEditingController();
  late PostModel post;
  bool isLoading = true;
  bool isPostingComment = false;
  bool isPostingReplyComment = false;
  bool isSelectingItem = false;
  bool isSelectingItemIsReplyComment = false;
  late String parentCommentID;
  Comment? selectedItem;
  late List<Comment> commentList;
  bool isReplying = false;
  Comment? commentAreBeingReplied;
  List replyCommentsOfUser = [];

  _getPostContent() async {
    //post = await displayUsersCommentFirst(widget.postID);
    post = await getPostContent(widget.postID);
    commentList = post.comments;

    List<Comment> myComments = [];
    commentList.toList().forEach((element) async {
      //replyCommentsOfUser.addAll( await getAllReplyCommentOfUser(user_info.user!.uid, widget.postID, element.id));
      if (element.userID == user_info.user!.uid) {
        myComments.add(element);
        commentList.remove(element);
      }
    });
    myComments.sort(
      (a, b) => b.createDate.compareTo(a.createDate),
    );
    commentList = myComments + commentList;
    setState(() {
      isLoading = false;
    });
  }

  int index = 0;

  void _scrollUp() {
    _commentScrollController.animateTo(
      _commentScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    _commentScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    _getPostContent();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("phuoccccccccccccccc");
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: !isSelectingItem ? appBar(context) : selectedItemAppBar(context),
        backgroundColor: colors.backgroundColor,
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: colors.primaryColor, size: 30),
              )
            : SafeArea(
                child: Stack(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: SingleChildScrollView(
                      controller: _commentScrollController,
                      child: Column(
                        children: [
                          contentBlock(context),
                          isPostingComment
                              ? postingCommentBlock(context, commentContent)
                              : Container(),
                          ...commentList.map((e) {
                            ++index;
                            return AutoScrollTag(
                              key: ValueKey(index),
                              controller: _commentScrollController,
                              index: index,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommentWidget(
                                    cmt: e,
                                    isSelecting:
                                        isSelectingItem ? selectedItem!.id : "",
                                    postID: widget.postID,
                                    callback: () => setState(() {
                                      commentController.clear();
                                      commentController.text = "@${e.userID} ";
                                      commentController.selection =
                                          TextSelection.fromPosition(TextPosition(
                                              offset:
                                                  commentController.text.length));
                                      setState(() {
                                        commentAreBeingReplied = e;
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(focusNode);
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () => setState(() {
                                                isReplying = true;
                                              }));
                                    }),
                                  ),
                                  isPostingReplyComment
                                      ? commentAreBeingReplied == e
                                          ? postingReplyCommentBlock(
                                              context, commentContent)
                                          : Container()
                                      : Container()
                                ],
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 80,
                          )
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

  var focusNode = FocusNode();

  commentBlock(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: IntrinsicHeight(
          child: Column(
            children: [
              commentAreBeingReplied != null
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: Colors.grey,
                      height: isReplying ? 50 : 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "Replying to ${commentAreBeingReplied!.id}",
                                  style: GoogleFonts.readexPro(
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton(
                                onPressed: () {
                                  commentController.clear();
                                  setState(() {
                                    isReplying = false;
                                  });
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () => setState(() {
                                      commentAreBeingReplied = null;
                                    }),
                                  );
                                },
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close)),
                          )
                        ],
                      ),
                    )
                  : Container(),
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: colors.SN_postBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
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
                    Expanded(
                        child: TextField(
                      focusNode: focusNode,
                      controller: commentController,
                      autofocus: true,
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                          border: InputBorder.none,
                          hintText: "Write a comment"),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () async {
                        if (commentController.value.text.isNotEmpty) {
                          if (commentAreBeingReplied != null) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            commentContent = commentController.text;
                            isReplying = false;
                            setState(() {
                              isPostingReplyComment = true;
                            });
                            commentController.clear();
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            await postReplyComment(
                                commentContent,
                                user_info.user!.uid,
                                widget.postID,
                                commentAreBeingReplied!.id);
                            setState(() {
                              isPostingReplyComment = false;
                              commentAreBeingReplied = null;
                            });
                          } else {
                            _scrollUp();
                            FocusScope.of(context).requestFocus(FocusNode());
                            commentContent = commentController.text;
                            isPostingComment = true;
                            setState(() {});
                            commentController.clear();
                            await postComment(commentContent,
                                user_info.user!.uid, post.postID);
                            await _getPostContent();
                            isPostingComment = false;
                            setState(() {});
                          }
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
            ],
          ),
        ));
  }

  Widget postingCommentBlock(BuildContext context, String content) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 5000),
      color: isPostingComment ? Colors.black12 : colors.backgroundColor,
      child: PostingCommentWidget(content: content),
    );
  }

  Widget postingReplyCommentBlock(BuildContext context, String content) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 5000),
      color: isPostingComment ? Colors.black12 : colors.backgroundColor,
      child: PostingReplyCommentWidget(content: content),
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

  AppBar selectedItemAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
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
      actions: [
        selectedItem!.userID == user_info.user!.uid
            ? IconButton(
                onPressed: () async {
                  if (isSelectingItemIsReplyComment) {
                    await deleteReplyComment(
                        selectedItem!, widget.postID, parentCommentID);
                    Fluttertoast.showToast(
                        msg: "Deleted 1 reply comment",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      selectedItem = null;
                      isSelectingItem = false;
                    });
                  } else {
                    await deleteComment(selectedItem!, widget.postID);
                    Fluttertoast.showToast(
                        msg: "Deleted 1 comment",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    commentList.remove(selectedItem!);
                    setState(() {
                      post.comments.remove(selectedItem!);
                      selectedItem = null;
                      isSelectingItem = false;
                    });
                  }
                },
                icon: const Icon(Icons.delete))
            : IconButton(onPressed: () {}, icon: const Icon(Icons.error)),
      ],
      backgroundColor: colors.primaryColor,
      elevation: 0,
    );
  }
}
