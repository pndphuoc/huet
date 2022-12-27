import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/comment_model.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/model/user/user.dart';
import 'package:hue_t/providers/user_provider.dart';
import 'package:hue_t/view/social_network_network/posting_comment_widget.dart';
import 'package:hue_t/view/social_network_network/posting_reply_comment_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../animation/heart_animation.dart';
import '../../firebase_function/comment_function.dart';
import '../../constants/user_info.dart' as user_info;
import 'package:hue_t/constants/host_url.dart' as url;
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../firebase_function/common_function.dart';
import 'package:http/http.dart' as http;
import '../../providers/tourist_provider.dart';

class PostCommentsPage extends StatefulWidget {
  const PostCommentsPage({Key? key, required this.postID, required this.user}) : super(key: key);
  final String postID;
  final User user;
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
  bool isLoadingReplyComments = false;
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
  bool isLoadingPostContent = true;
  //send comment mode = 0 khi gửi comment, =1 khi reply 1 comment, =2 khi reply 1 reply của comment
  int sendCommentMode = 0;
  String? replyCommentIsBeingReplied;
  bool isGettingMoreComments = false;

  _getPostContent() async {
    //post = await displayUsersCommentFirst(widget.postID);
    post = await getPostContent(widget.postID, commentLimit);
    setState(() {
      isLoadingPostContent = false;
    });
  }

  Future<User> getUser(String userID) async {
    final response = await http.get(
      Uri.parse('${url.url}/api/user/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      return User(
          name: jsonObject['name'],
          mail: jsonObject['email'],
          photoURL: jsonObject['image'],
          uid: jsonObject['_id'],
          password: jsonObject['password'],
          phoneNumber: jsonObject['phone'],
          isGoogle: jsonObject['isGoogle']);
    } else {
      throw Exception("User invalid");
    }
  }

  _getComments() async {
    commentList = await getPostComments(widget.postID, commentLimit);
    if(commentList.isEmpty)
      {
        setState(() {
          isLoading = false;
        });
        return;
      }
    List<Comment> myComments = [];
/*    commentList.toList().forEach((element) async {
      //replyCommentsOfUser.addAll( await getAllReplyCommentOfUser(user_info.user!.uid, widget.postID, element.id));
      element.user = await getUser(element.userID);
      if (element.userID == user_info.user!.uid) {
        myComments.add(element);
        commentList.remove(element);
      }
    });*/
    for(var cmt in commentList.toList()) {
      cmt.user = await getUser(cmt.userID);
      if (cmt.userID == user_info.user!.uid) {
        myComments.add(cmt);
        commentList.remove(cmt);
      }
    }
    myComments.sort(
      (a, b) => b.createDate.compareTo(a.createDate),
    );
    commentList = myComments + commentList;
    print(commentList.first.user!.name);
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
    print(user_info.user!.uid);
    _commentScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    _getPostContent();
    _getComments();

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
    await _getComments();
    // if failed,use refreshFailed()
    setState(() {
      isRefreshing = false;
      _refreshController.refreshCompleted();
    });

  }

  _getMoreComments() async {
    if (_moreCommentsAvailable == false) {
      _refreshController.loadComplete();
      return;
    }
   setState(() {
     isGettingMoreComments = true;
   });
    List<Comment> moreCommentsList = [];
    if (!isPostingComment && !isPostingReplyComment) {
      moreCommentsList = await getMoreComments(widget.postID, commentLimit);
    }
    if (moreCommentsList.length < commentLimit) {
      _moreCommentsAvailable = false;
    }

    for (var e in moreCommentsList) {
      e.replyComments = await getAllReplyCommentOfUser(
          user_info.user!.uid, widget.postID, e.id);
      e.replyComments!.sort(
        (a, b) => a.createDate.compareTo(b.createDate),
      );
    }

    commentList.addAll(moreCommentsList);
    setState(() {});
    _refreshController.loadComplete();
    isGettingMoreComments = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return true;
        },
        child: Scaffold(
          appBar: appBar(context),
          backgroundColor: colors.backgroundColor,
          body: Column(
            children: [
              isLoadingPostContent
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: colors.primaryColor, size: 30),
                    )
                  : contentBlock(context),
              isPostingComment
                  ? postingCommentBlock(context, commentContent)
                  : Container(),
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.discreteCircle(
                            color: colors.primaryColor, size: 30),
                      )
                    : SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: !isGettingMoreComments? true : false,
                        enablePullUp: isLoading == false && isRefreshing == false ? true : false,
                        header: WaterDropMaterialHeader(
                          backgroundColor: colors.backgroundColor,
                          color: colors.primaryColor,
                        ),
                        onRefresh: _onRefresh,
                        onLoading: _getMoreComments,
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
                                                  color: colors.primaryColor,
                                                  size: 15),
                                            )
                                          else if(commentList[index].replyCount! > commentList[index].replyComments!.where((element) => element.userID == user_info.user!.uid).length)
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
                                                  commentList[index])),
                                        //Hiển thị widget posting của reply comment
                                        isPostingReplyComment &&
                                            commentAreBeingReplied ==
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
                                                  commentList[index]))
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
          SizedBox(
            height: 45,
            width: 45,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.user.photoURL),
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
                    widget.user.name,
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
                                "Replying to ${commentAreBeingReplied!.user!.name}",
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
                                sendCommentMode = 0;
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
                      if (commentController.value.text.trim().isNotEmpty) {
                        if(sendCommentMode == 0) {
                          _commentScrollController.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn);
                          FocusScope.of(context).requestFocus(FocusNode());
                          commentContent = commentController.text.trim();
                          isPostingComment = true;
                          setState(() {});
                          commentController.clear();
                          final justPostComment = await getComment(
                              widget.postID,
                              await postComment(commentContent,
                                  user_info.user!.uid, widget.postID));
                          justPostComment.replyComments = [];
                          justPostComment.replyCount = 0;
                          justPostComment.user = user_info.user;
                          commentList.insert(0, justPostComment);
                          //await _getPostContent();
                          isPostingComment = false;
                          setState(() {});
                        }
                        else if(sendCommentMode == 1) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          commentContent = commentController.text.trim();
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
                          final temp = commentList[commentList.indexOf(commentAreBeingReplied!)];
                          temp.replyComments!.add(justPostReplyComment);
                          temp.replyCount = await getReplyCommentCount(widget.postID, temp.id);
                          commentList[commentList
                              .indexOf(commentAreBeingReplied!)] = temp;
                          //await _getPostContent();
                          setState(() {
                            //isShowingCommentsOfCurrentUser = true;
                            isPostingReplyComment = false;
                            commentAreBeingReplied = null;
                          });
                        } else {
                          FocusScope.of(context).requestFocus(FocusNode());
                          commentContent = commentController.text.trim();
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
                          temp.replyCount = await getReplyCommentCount(widget.postID, temp.id);
                          commentList[commentList
                              .indexOf(commentAreBeingReplied!)] = temp;
                          //await _getPostContent();
                          setState(() {
                            isPostingReplyComment = false;
                            commentAreBeingReplied = null;
                          });
                        }
                      }
                      sendCommentMode = 0;
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
            sendCommentMode = 1;
            commentAreBeingReplied = cmt;
            isReplying = true;
            focusNode.requestFocus();
            commentController.text = "@${commentAreBeingReplied!.user!.name} ";
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
                child: SizedBox(
                  width: double.infinity,
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
                  ),
                )),
            TextButton(
                onPressed: () {},
                child: SizedBox(
                  width: double.infinity,
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
                  ),
                )),
            TextButton(
                onPressed: () {},
                child: SizedBox(
                  width: double.infinity,
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
                  ),
                )),
            selectedItem!.userID == user_info.user!.uid
                ? TextButton(
                    onPressed: () {},
                    child: SizedBox(
                      width: double.infinity,
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
                      ),
                    ))
                : Container(),
            selectedItem!.userID == user_info.user!.uid
                ? TextButton(
                    onPressed: () {
                      if (parentCmtId.isEmpty) {
                        (() async {
                          await deleteComment(selectedItem!.id, widget.postID);
                        })();
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
                        (() async {
                          await deleteReplyComment(
                              selectedItem!.id, widget.postID, parentCmtId);
                        })();
                        final index = commentList.lastIndexWhere(
                                (element) => element.id == parentCmtId);
                        commentList[index]
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
                    child: SizedBox(
                      width: double.infinity,
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
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildCommentBlock(BuildContext context, Comment cmt) {
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
                        backgroundImage: CachedNetworkImageProvider(cmt.user!.photoURL),
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
                                cmt.user!.name,
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
                          IconButton(
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
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.favorite_outline_rounded,
                                    size: 20,
                                  ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          if(cmt.likeCount! > 0) Text(
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
                    "----- Read ${isShowingCommentsOfCurrentUser ? cmt.replyCount! -  commentList[index].replyComments!.where((element) => element.userID == user_info.user!.uid).length : cmt.replyCount!} reply comments",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )
                : Text(
                    "----- Hide ${cmt.replyCount} reply comments",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  )));
  }

  Widget buildReplyCommentBlock(
      BuildContext context, Comment cmt, Comment parentCmt) {
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
                        return buildModalBottom(context, parentCmt.id);
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
                              cmt, widget.postID, parentCmt.id);
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
          Container(
            width: 60,
            margin: const EdgeInsets.only(left: 45),
            child: TextButton(
                onPressed: () {
                  sendCommentMode = 2;
                  replyCommentIsBeingReplied = cmt.id;
                  commentAreBeingReplied = parentCmt;
                  isReplying = true;
                  focusNode.requestFocus();
                  commentController.text = "@${commentAreBeingReplied!.id} ";
                  commentController.selection = TextSelection.collapsed(
                      offset: commentController.text.length);
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
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }
}

