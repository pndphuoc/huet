import 'dart:convert';
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/model/user/user.dart';
import 'package:hue_t/providers/tourist_provider.dart';
import 'package:hue_t/providers/user_provider.dart';
import 'package:hue_t/view/social_network_network/post_comments.dart';
import 'package:hue_t/view/social_network_network/social_network.dart';
import 'package:hue_t/view/social_network_network/video_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import '../../constants/user_info.dart' as user_info;
import '../tourist_attraction/tourist_attraction_detail.dart';

class Post extends StatefulWidget {
  const Post(
      {Key? key,
      required this.post,
      required this.isInView,
      required this.callback,
      required this.user})
      : super(key: key);
  final PostModel post;
  final bool isInView;
  final DeleteCallback callback;
  final User user;

  @override
  State<Post> createState() => _PostState();
}

typedef void DeleteCallback(String val);

late String documentSnapshotID;
late PostModel post;

class _PostState extends State<Post> with TickerProviderStateMixin {
  SocialNetWorkPage? socialNetworkPage;

  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  //CachedVideoPlayerController? _controller;
  int currentPos = 0;
  bool isHeartAnimating = false;
  bool isHeartButtonAnimating = false;
  bool isMark = false;
  String? selectedValue;
  late int likeCount;
  late User userOfPost;
  bool isLoading = true;
  bool isPlayingVideo = true;

/*  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }*/

  Future<void> _likeAndUnlikePost() async {
    final docPost =
        FirebaseFirestore.instance.collection('post').doc(widget.post.postID);
    if (!widget.post.isLiked!) {
      docPost.update({
        'likedUsers': FieldValue.arrayUnion([user_info.user!.uid])
      });
      likeCount += 1;
    } else {
      docPost.update({
        'likedUsers': FieldValue.arrayRemove([user_info.user!.uid])
      });
      likeCount -= 1;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //documentSnapshotID = widget.documentSnapshot.id;
    post = widget.post;
    likeCount = post.likedUsers.length;
  }

  Widget buildNameAndAttraction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Consumer<UserProvider>(builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                height: 50,
                width: 50,
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(widget.user.photoURL),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: GoogleFonts.readexPro(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Consumer<TouristAttractionProvider>(
                    builder: (context, value, child) {
                      TouristAttraction att = value.list
                          .where((element) =>
                              element.id == widget.post.attractionID)
                          .toList()
                          .first;
                      return TextButton(
                        onPressed: () {
                          Navigator.of(context).push(SwipeablePageRoute(
                            builder: (BuildContext context) =>
                                TouristAttractionDetail(item: att),
                          ));
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Text(att.title,
                            style: GoogleFonts.readexPro(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(Icons.more_vert_outlined),
                items: [
                  if (widget.post.userID == user_info.user!.uid)
                    ...MenuItems.itemsListForPostOfCurrentUser.map((e) =>
                        DropdownMenuItem(
                            value: e, child: MenuItems.buildItem(e)))
                  else
                    ...MenuItems.itemsListForPostNotOfCurrentUser.map((e) =>
                        DropdownMenuItem(
                            value: e, child: MenuItems.buildItem(e)))
                ],
                onChanged: (value) {
                  MenuItem selected = value as MenuItem;
                  if (selected.text == 'Delete') {
                    widget.callback(widget.post.postID.toString());
                  }
                  MenuItems.onChanged(context, value as MenuItem);
                },
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 16, right: 16),
                dropdownWidth: 100,
                dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: colors.backgroundColor,
                ),
                dropdownElevation: 0,
                offset: const Offset(-70, -10),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildMediasBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
      width: double.infinity,
      child: GestureDetector(
        onDoubleTap: () {
          if (!widget.post.isLiked!) {
            _likeAndUnlikePost();
          }
          setState(() {
            widget.post.isLiked = true;
            isHeartAnimating = true;
            isHeartButtonAnimating = true;
          });
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 1,
                    reverse: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) async {
                      //loadVideo(widget.samplePost.medias[index]);
                      setState(() {
                        currentPos = index;
                      });
                    }),
                items: widget.post.medias.map((e) {
                  return Builder(builder: (BuildContext context) {
                    if (e.isPhoto) {
                      return CachedNetworkImage(
                        imageUrl: e.url,
                        imageBuilder: (context, imageProvider) => Image(
                          image: CachedNetworkImageProvider(e.url),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Center(
                          child: LoadingAnimationWidget.discreteCircle(
                              color: colors.primaryColor, size: 40),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    } else {
                      if (widget.isInView && isPlayingVideo) {
                        return VideoWidget(url: e.url, play: true);
                      } else {
                        return VideoWidget(url: e.url, play: false);
                      }

                      Center(
                        child: LoadingAnimationWidget.discreteCircle(
                            color: colors.primaryColor, size: 30),
                      );
                    }
                  });
                }).toList(),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 1,
              right: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.post.medias.map((e) {
                  int index = widget.post.medias.indexOf(e);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: currentPos == index ? 12 : 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: currentPos == index
                            ? BoxShape.rectangle
                            : BoxShape.rectangle,
                        borderRadius: currentPos == index
                            ? BorderRadius.circular(8)
                            : BorderRadius.circular(8),
                        color: currentPos == index
                            ? const Color.fromRGBO(255, 255, 255, 10)
                            : const Color.fromRGBO(236, 236, 236, 0.5)),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: isHeartAnimating ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: HeartAnimation(
                    onEnd: () => setState(() => isHeartAnimating = false),
                    duration: const Duration(milliseconds: 500),
                    isAnimating: isHeartAnimating,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: isHeartAnimating ? 120 : 0,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildActionBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _likeAndUnlikePost();
                  setState(() {
                    widget.post.isLiked = !widget.post.isLiked!;
                    isHeartButtonAnimating = !isHeartButtonAnimating;
                    _heartController.forward();
                  });
                },
                child: Row(
                  children: [
                    HeartAnimation(
                      isAnimating: isHeartButtonAnimating || isHeartAnimating,
                      ////
                      child: widget.post.isLiked!
                          ? const Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                              size: 30,
                            )
                          : const Icon(
                              Icons.favorite_outline_rounded,
                              size: 30,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      likeCount.toString(),
                      style: GoogleFonts.readexPro(
                        color: colors.SN_postTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isPlayingVideo = false;
                  });

                  isPlayingVideo = await Navigator.push(
                    context,
                    SwipeablePageRoute(
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionBuilder: (context, animation,
                          secondaryAnimation, isSwipeGesture, child) {
                        // Use a custom transition animation
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      builder: (context) {
                        return PostCommentsPage(
                          postID: widget.post.postID,
                          user: widget.user,
                        );
                      },
                    ),
                  );
                  /*isPlayingVideo = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        // Use a custom transition animation
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return PostCommentsPage(
                          postID: widget.post.postID,
                          user: widget.user,
                        );
                      },
                    ),
                  );*/
                  setState(() {});
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.mode_comment_outlined,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.post.commentsCount.toString(),
                      style: GoogleFonts.readexPro(
                        color: colors.SN_postTextColor,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                isMark = !isMark;
              });
            },
            icon: isMark
                ? Icon(
                    Icons.bookmark,
                    size: 30,
                    color: colors.primaryColor,
                  )
                : const Icon(
                    Icons.bookmark_outline,
                    size: 30,
                  ),
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: EdgeInsets.zero,
          )
        ],
      ),
    );
  }

  Widget buildCaptionBlock(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Text(
          widget.post.caption!,
          style: GoogleFonts.readexPro(color: Colors.black, fontSize: 16),
        ));
  }

  Widget buildCommentBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 30,
            width: 30,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/socialNetwork/avatar.png",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Expanded(
              child: SizedBox(
            child: TextField(
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  hintText: "Write a comment",
                  border: InputBorder.none),
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
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          )
        ],
      ),
    );
  }

  Widget buildCreateDateBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: buildDateFormat(widget.post.createDate, Colors.grey, 10),
    );
  }

  Widget buildDateFormat(DateTime createDate, Color color, double fontSize) {
    return Text(
      // 86400
      daysBetween(createDate, DateTime.now()) < 60
          ?
          //Nếu dưới 60 giây
          "${daysBetween(createDate, DateTime.now())} seconds ago"
          :
          // Trên 60 giây, đổi sang phút
          (daysBetween(createDate, DateTime.now()) / 60).round() < 60
              ?
              //Dưới 60 phút
              "${(daysBetween(createDate, DateTime.now()) / 60).round()} minutes ago"
              :
              //Trên 60 phút, đổi sang giờ
              (daysBetween(createDate, DateTime.now()) / (60 * 60)).round() < 24
                  ?
                  //Dưới 24 giờ
                  "${(daysBetween(createDate, DateTime.now()) / (60 * 60)).round()} hours ago"
                  :
                  //Trên 24 giờ, đổi sang ngày
                  (daysBetween(createDate, DateTime.now()) / (24 * 60 * 60))
                              .round() <
                          7
                      ?
                      //Dưới 7 ngày
                      "${(daysBetween(createDate, DateTime.now()) / (24 * 60 * 60)).round()} days ago"
                      :
                      //Trên 7 ngày
                      DateFormat('dd-MM-yy').format(createDate),
      style: GoogleFonts.readexPro(fontSize: fontSize, color: color),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    return (to.difference(from).inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    var attractionProvider = Provider.of<TouristAttractionProvider>(context);
    if (attractionProvider.list.isEmpty) {
      attractionProvider.getAll();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: colors.primaryColor, size: 30),
          )
        : Container(
            margin:
                const EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: colors.SN_postBackgroundColor,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNameAndAttraction(context),
                buildMediasBlock(context),
                buildActionBlock(context),
                widget.post.caption!.isNotEmpty
                    ? buildCaptionBlock(context)
                    : Container(),
                buildCreateDateBlock(context),
                const SizedBox(
                  height: 20,
                )
                //buildCommentBlock(context)
              ],
            ),
          );
  }
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}

class MenuItems {
  static const List<MenuItem> itemsListForPostOfCurrentUser = [
    delete,
    edit,
    report
  ];
  static const List<MenuItem> itemsListForPostNotOfCurrentUser = [report];

  //static const List<MenuItem> secondItems = [logout];

  static const delete = MenuItem(text: 'Delete');
  static const edit = MenuItem(text: 'Edit');
  static const report = MenuItem(text: 'Report');

/*  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);*/

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.delete:
        break;
      case MenuItems.edit:
        break;
      case MenuItems.report:
        break;
/*      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:*/
        //Do something
        break;
    }
  }
}
