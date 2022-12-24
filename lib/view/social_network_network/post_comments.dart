import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/view/social_network_network/posting_comment_widget.dart';
import 'package:hue_t/view/social_network_network/posting_reply_comment_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../animation/heart_animation.dart';
import '../../firebase_function/comment_function.dart';
import '../../constants/user_info.dart' as user_info;
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../firebase_function/common_function.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage({Key? key, required this.postID}) : super(key: key);
  final String postID;

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage>
    with TickerProviderStateMixin {
  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  final ScrollController _controller = ScrollController();

  late AutoScrollController _commentScrollController;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late String commentContent;

  final commentController = TextEditingController();

  late PostModel post;
  bool isLoading = true;
  bool isPostingComment = false;
  bool isPostingReplyComment = false;
  bool isSelectingItem = false;
  bool isSelectingItemIsReplyComment = false;
  bool isLoadingReplyComments = false;
  late String parentCommentID;
  Comment? selectedItem;
  late List<Comment> commentList;
  bool isReplying = false;
  Comment? commentAreBeingReplied;
  List replyCommentsOfUser = [];
  List<Comment> showReplyCommentList = [];
  Comment? commentIsLoadingReply;
  bool isHeartAnimating = false;
  bool isShowingCommentsOfCurrentUser = true;
  bool _moreCommentsAvailable = true;
  static const int commentLimit = 10;
  bool isRefreshing = false;

  _getPostContent() async {
    //post = await displayUsersCommentFirst(widget.postID);
    post = await getPostContent(widget.postID, commentLimit);
    commentList = post.comments!;

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

    for (var e in commentList) {
      e.replyComments = await getAllReplyCommentOfUser(
          user_info.user!.uid, widget.postID, e.id);
      e.replyComments!.sort(
        (a, b) => a.createDate.compareTo(b.createDate),
      );
    }
    setState(() {
      isShowingCommentsOfCurrentUser = true;
      isLoading = false;
    });
  }

  int index = 0;

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

  void _onRefresh() async {
    commentList.clear();
    setState(() {
      isRefreshing = true;
      _moreCommentsAvailable = true;
    });

    // monitor network fetch
    await _getPostContent();
    // if failed,use refreshFailed()
    setState(() {
      isRefreshing = false;
    });
    _refreshController.refreshCompleted();
  }

  _getMoreComments() async {
    if (_moreCommentsAvailable == false) {
      _refreshController.loadComplete();
      return;
    }
    List<Comment> moreCommentsList = [];
    if (!isPostingComment && !isPostingReplyComment) {
      moreCommentsList = await getMoreComments(widget.postID, commentLimit);
    }
    if (moreCommentsList.length < commentLimit) {
      _moreCommentsAvailable = false;
    }

    for (var e in moreCommentsList) {
      e.replyCount = await getReplyCommentCount(widget.postID, e.id);
      e.replyComments = await getAllReplyCommentOfUser(
          user_info.user!.uid, widget.postID, e.id);
      e.replyComments!.sort(
        (a, b) => a.createDate.compareTo(b.createDate),
      );
    }

    commentList.addAll(moreCommentsList);
    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appBar(context),
        backgroundColor: colors.backgroundColor,
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: colors.primaryColor, size: 30),
              )
            : /*SingleChildScrollView(
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
                            buildCommentBlock(context, e),
                            if (e.replyCount! > 0)
                              if (isLoadingReplyComments &&
                                  commentIsLoadingReply != null &&
                                  commentIsLoadingReply == e)
                                Center(
                                  child: LoadingAnimationWidget.fallingDot(
                                      color: colors.primaryColor, size: 15),
                                )
                              else
                                buildReadReplyCommentButton(
                                    context, widget.postID, e),
                            //Hiển thị widget posting của reply comment
                            isPostingReplyComment
                                ? postingReplyCommentBlock(
                                    context, commentContent)
                                : Container(),

                            //Hiển thị các reply comment của user hiện tại
                            if (e.replyComments!.isNotEmpty &&
                                !showReplyCommentList.contains(e) &&
                                isShowingCommentsOfCurrentUser)
                              ...e.replyComments!.map(
                                  (replyCommentOfCurrentUser) =>
                                      buildReplyCommentBlock(context,
                                          replyCommentOfCurrentUser, e.id)),

                            //Hiển thị các reply comment
                            if (showReplyCommentList.contains(e) &&
                                e.replyComments != null)
                              ...e.replyComments!.map((reply) =>
                                  buildReplyCommentBlock(context, reply, e.id))
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),*/
            Column(
                children: [
                  contentBlock(context),
                  isPostingComment
                      ? postingCommentBlock(context, commentContent)
                      : Container(),
                  Expanded(
                    child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropMaterialHeader(
                          backgroundColor: colors.backgroundColor,
                          color: colors.primaryColor,
                        ),
                        onRefresh: _onRefresh,
                        onLoading: !isLoading && !isRefreshing
                            ? _getMoreComments
                            : () {},
                        child: ListView.builder(
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  AutoScrollTag(
                                    key: ValueKey(index),
                                    controller: _commentScrollController,
                                    index: index,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildCommentBlock(
                                            context, commentList[index]),
                                        if (commentList[index].replyCount! > 0)
                                          if (isLoadingReplyComments &&
                                              commentIsLoadingReply != null &&
                                              commentIsLoadingReply ==
                                                  commentList[index])
                                            Center(
                                              child: LoadingAnimationWidget
                                                  .fallingDot(
                                                      color:
                                                          colors.primaryColor,
                                                      size: 15),
                                            )
                                          else
                                            buildReadReplyCommentButton(
                                                context,
                                                widget.postID,
                                                commentList[index]),

                                        //Hiển thị các reply comment của user hiện tại
                                        if (commentList[index]
                                                .replyComments!
                                                .isNotEmpty &&
                                            !showReplyCommentList
                                                .contains(commentList[index]) &&
                                            isShowingCommentsOfCurrentUser)
                                          ...commentList[index]
                                              .replyComments!
                                              .map((replyCommentOfCurrentUser) =>
                                                  buildReplyCommentBlock(
                                                      context,
                                                      replyCommentOfCurrentUser,
                                                      commentList[index].id)),
//Hiển thị widget posting của reply comment
                                        isPostingReplyComment &&
                                                commentAreBeingReplied! ==
                                                    commentList[index]
                                            ? postingReplyCommentBlock(
                                                context, commentContent)
                                            : Container(),
                                        //Hiển thị các reply comment
                                        if (showReplyCommentList
                                                .contains(commentList[index]) &&
                                            commentList[index].replyComments !=
                                                null)
                                          ...commentList[index]
                                              .replyComments!
                                              .map((reply) =>
                                                  buildReplyCommentBlock(
                                                      context,
                                                      reply,
                                                      commentList[index].id))
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })),
                  )
                ],
              ),
        bottomNavigationBar: buildWritingCommentBlock(context),
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

  Widget buildWritingCommentBlock(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
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
                                style:
                                    GoogleFonts.readexPro(color: Colors.white),
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
                      //Nếu text không rỗng
                      if (commentController.value.text.isNotEmpty) {
                        //Kiểm tra có phải là reply 1 comment hay không
                        if (commentAreBeingReplied != null) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          commentContent = commentController.text;
                          isReplying = false;
                          setState(() {
                            isPostingReplyComment = true;
                          });
                          commentController.clear();
                          final justPostReplyComment = await getReplyComment(
                              widget.postID,
                              commentAreBeingReplied!.id,
                              await postReplyComment(
                                  commentContent,
                                  user_info.user!.uid,
                                  widget.postID,
                                  commentAreBeingReplied!.id));
                          final temp = commentList[
                              commentList.indexOf(commentAreBeingReplied!)];
                          temp.replyComments!.add(justPostReplyComment);
                          temp.replyCount = 0;
                          commentList[commentList
                              .indexOf(commentAreBeingReplied!)] = temp;
                          //await _getPostContent();
                          setState(() {
                            isPostingReplyComment = false;
                            commentAreBeingReplied = null;
                          });
                        } else {
                          // Nếu không thì là đang comment
                          //_scrollUp();
                          _commentScrollController.animateTo(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn);
                          FocusScope.of(context).requestFocus(FocusNode());
                          commentContent = commentController.text;
                          isPostingComment = true;
                          setState(() {});
                          commentController.clear();
                          final justPostComment = await getComment(
                              widget.postID,
                              await postComment(commentContent,
                                  user_info.user!.uid, widget.postID));
                          justPostComment.replyComments = [];
                          justPostComment.replyCount = 0;
                          commentList.insert(0, justPostComment);
                          //await _getPostContent();
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
      ),
    );
  }

  Widget postingCommentBlock(BuildContext context, String content) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 5000),
      color: Colors.black12,
      child: PostingCommentWidget(content: content),
    );
  }

  Widget postingReplyCommentBlock(BuildContext context, String content) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 5000),
      color: Colors.black12,
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

  Widget buildReplyButton(BuildContext context, Comment cmt) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(left: 45),
      child: TextButton(
          onPressed: () {
            commentAreBeingReplied = cmt;
            isReplying = true;
            focusNode.requestFocus();
            commentController.text = "@${commentAreBeingReplied!.id} ";
            commentController.selection =
                TextSelection.collapsed(offset: commentController.text.length);
            setState(() {});
          },
          style: TextButton.styleFrom(
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
              alignment: Alignment.center),
          child: Text(
            "Reply",
            style: GoogleFonts.readexPro(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
          )),
    );
  }

  Widget buildModalBottom(BuildContext context, String parentCmtId) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colors.backgroundColor,
      ),
      padding: const EdgeInsets.all(15),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.report_outlined,
                      color: Colors.black,
                    )),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    TextSpan(
                        text: "Report",
                        style: GoogleFonts.readexPro(
                            fontSize: 20, color: Colors.black))
                  ]),
                )),
            TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.reply_outlined,
                      color: Colors.black,
                    )),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    TextSpan(
                        text: "Reply",
                        style: GoogleFonts.readexPro(
                            fontSize: 20, color: Colors.black))
                  ]),
                )),
            TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(
                        child: Icon(
                      Icons.copy_outlined,
                      color: Colors.black,
                    )),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    TextSpan(
                        text: "Copy to clipboard",
                        style: GoogleFonts.readexPro(
                            fontSize: 20, color: Colors.black))
                  ]),
                )),
            selectedItem!.userID == user_info.user!.uid
                ? TextButton(
                    onPressed: () {},
                    child: RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                            child: Icon(
                          Icons.mode_edit_outline,
                          color: Colors.black,
                        )),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        TextSpan(
                            text: "Edit",
                            style: GoogleFonts.readexPro(
                                fontSize: 20, color: Colors.black))
                      ]),
                    ))
                : Container(),
            selectedItem!.userID == user_info.user!.uid
                ? TextButton(
                    onPressed: () async {
                      if (parentCmtId.isEmpty) {
                        await deleteComment(selectedItem!.id, widget.postID);
                        commentList.remove(selectedItem!);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Deleted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {});
                      } else {
                        await deleteReplyComment(
                            selectedItem!.id, widget.postID, parentCmtId);
                        commentList[commentList.lastIndexWhere(
                                (element) => element.id == parentCmtId)]
                            .replyComments!
                            .remove(selectedItem!);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Deleted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {});
                      }
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                            child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        )),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        TextSpan(
                            text: "Delete",
                            style: GoogleFonts.readexPro(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold))
                      ]),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildCommentBlock(BuildContext context, Comment cmt) {
    bool isSelectingItem = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPressStart: (details) async {
            selectedItem = cmt;
            setState(() {});
            //_showPopupMenuForComment(details.globalPosition, cmt);
            await showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return buildModalBottom(context, "");
              },
            );
            selectedItem = null;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
                color: selectedItem == cmt
                    ? Colors.black12
                    : colors.backgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user_info.user!.photoURL,
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
                                user_info.user!.name,
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
                            cmt.content,
                            style: GoogleFonts.montserrat(
                                color: Colors.black, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          buildDateFormat(cmt.createDate, Colors.grey, 10),
                        ],
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
                              onPressed: () {
                                likeAndUnlikeComment(cmt, widget.postID);
                                cmt.isLiked = !cmt.isLiked!;
                                if (cmt.isLiked!) {
                                  cmt.likeCount = cmt.likeCount! + 1;
                                } else {
                                  cmt.likeCount = cmt.likeCount! - 1;
                                }
                                setState(() {
                                  isHeartAnimating = !isHeartAnimating;

                                  _heartController.forward();
                                });
                              },
                              icon: cmt.isLiked!
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
                            cmt.likeCount.toString(),
                            style: GoogleFonts.readexPro(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                buildReplyButton(context, cmt),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReadReplyCommentButton(
      BuildContext context, String postID, Comment cmt) {
    return Container(
        margin: const EdgeInsets.only(left: 55),
        child: TextButton(
            onPressed: () async {
              /*   replyList = await getReplyComments(postID, cmtID);
              print(replyList.length);*/
              if (!showReplyCommentList.contains(cmt)) {
                showReplyCommentList.add(cmt);
                isLoadingReplyComments = true;
                commentIsLoadingReply = cmt;
                setState(() {});
                cmt.replyComments!.clear();
                cmt.replyComments = await getReplyComments(postID, cmt.id);
                setState(() {
                  isLoadingReplyComments = false;
                });
              } else {
                showReplyCommentList.remove(cmt);
                isShowingCommentsOfCurrentUser = false;
                setState(() {});
              }
              setState(() {});
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: !showReplyCommentList.contains(cmt)
                ? Text(
                    "----- Read ${cmt.replyCount} reply comments",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )
                : Text(
                    "----- Hide ${cmt.replyCount} reply comments",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )));
  }

  Widget buildReplyCommentBlock(
      BuildContext context, Comment cmt, String parentCmtID) {
    return Container(
      decoration: BoxDecoration(
          color: selectedItem == cmt ? Colors.black12 : colors.backgroundColor),
      padding: const EdgeInsets.only(left: 55, top: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
                width: 35,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user_info.user!.photoURL,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPressStart: (details) async {
                    //_showPopupMenu(details.globalPosition);
                    selectedItem = cmt;
                    setState(() {});
                    //_showPopupMenuForComment(details.globalPosition, cmt);
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return buildModalBottom(context, parentCmtID);
                      },
                    );
                    selectedItem = null;
                    setState(() {});
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
                        user_info.user!.name,
                        style: GoogleFonts.readexPro(
                            color: Colors.black, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        cmt.content,
                        style: GoogleFonts.montserrat(
                            color: Colors.black, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      buildDateFormat(cmt.createDate, Colors.grey, 10),
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
                      isAnimating: false, ////
                      child: IconButton(
                        onPressed: () async {
                          await likeAndUnlikeReplyComment(
                              cmt, widget.postID, parentCmtID);
                          cmt.isLiked = !cmt.isLiked!;
                          if (cmt.isLiked!) {
                            cmt.likeCount = cmt.likeCount! + 1;
                          } else {
                            cmt.likeCount = cmt.likeCount! - 1;
                          }
                          setState(() {
                            /*  likeAndUnlikeComment();
                            isLiked = !isLiked;
                            isHeartAnimating = !isHeartAnimating;
                            _heartController.forward();*/
                          });
                        },
                        icon: cmt.isLiked!
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
                      cmt.likeCount.toString(),
                      style: GoogleFonts.readexPro(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
          buildReplyButton(context, cmt),
        ],
      ),
    );
  }
}
