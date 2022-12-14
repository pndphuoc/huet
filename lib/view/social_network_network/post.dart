import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post_comments.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  const Post({Key? key, required this.samplePost}) : super(key: key);
  final PostModel samplePost;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with TickerProviderStateMixin {
  late final AnimationController _heartController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late VideoPlayerController _controller;
  int currentPos = 0;
  bool isLiked = false;
  bool isHeartAnimating = false;
  bool isHeartButtonAnimating = false;
  bool isMark = false;

/*  Future<void> loadVideo(String url) async {
    controller = CachedVideoPlayerController.network(url);
    controller.initialize().then((value) {
      controller.play();
      setState(() {});
    });
  }*/

  @override
  void dispose() {
    _heartController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void loadVideo(String url) {
    _controller = VideoPlayerController.network(
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //_controller.play();
        setState(() {});
      });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //_controller.play();
        setState(() {});
      });
  }

  Widget buildNameAndAttraction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              height: 50,
              width: 50,
              child: const CircleAvatar(
                backgroundImage:
                AssetImage("assets/images/socialNetwork/jennieAvatar.png"),
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "jennierubyjane",
                  style: GoogleFonts.readexPro(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text("Trường Đại học Khoa học Huế",
                      style: GoogleFonts.readexPro(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_outlined),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }

  Widget buildMediasBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
      width: double.infinity,
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            isLiked = true;
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
/*                      if (controller.value.isInitialized)
                        {
                          controller.dispose();
                        }*/
/*                      if (widget.samplePost.medias[index].isPhoto == false) {
                        await loadVideo(widget.samplePost.medias[index].url);
                      }*/
                      setState(() {
                        currentPos = index;
                      });
                    }),
                items: widget.samplePost.medias.map((e) {
/*                  if(!e.isPhoto) {
                    loadVideo(e.url);
                  }*/
                print(e.url);
                  return Builder(builder: (BuildContext context) {
                    if (e.isPhoto) {
                      return CachedNetworkImage(
                        imageUrl: e.url,
                        imageBuilder: (context, imageProvider) =>
                            Image(
                              image: CachedNetworkImageProvider(e.url),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                        placeholder: (context, url) =>
                            Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                  color: colors.primaryColor, size: 40),
                            ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      );
                    }
                    else {
                      return _controller.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                          : Container(child: Text("error"),);
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
                children: widget.samplePost.medias.map((e) {
                  int index = widget.samplePost.medias.indexOf(e);
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
              HeartAnimation(
                isAnimating: isHeartButtonAnimating || isHeartAnimating, ////
                child: IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      isHeartButtonAnimating = !isHeartButtonAnimating;
                      _heartController.forward();
                    });
                  },
                  icon: isLiked
                      ? const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                    size: 30,
                  )
                      : const Icon(
                    Icons.favorite_outline_rounded,
                    size: 30,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.samplePost.likeCount.toString(),
                style: GoogleFonts.readexPro(
                  color: colors.SN_postTextColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostCommentsPage(
                                post: widget.samplePost,
                              )));
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                icon: const Icon(
                  Icons.mode_comment_outlined,
                  size: 30,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.samplePost.commentCount.toString(),
                style: GoogleFonts.readexPro(
                  color: colors.SN_postTextColor,
                  fontSize: 15,
                ),
              )
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
          widget.samplePost.caption!,
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
      child: buildDateFormat(widget.samplePost.createDate),
    );
  }

  Widget buildDateFormat(DateTime createDate) {
    return Text( // 86400
      daysBetween(createDate, DateTime.now()) < 60 ?
      //Nếu dưới 60 giây
      "${daysBetween(createDate, DateTime.now())} seconds ago" :
      // Trên 60 giây, đổi sang phút
      (daysBetween(createDate, DateTime.now()) / 60).round() < 60 ?
      //Dưới 60 phút
      "${(daysBetween(createDate, DateTime.now()) / 60).round()} minutes ago" :
      //Trên 60 phút, đổi sang giờ
      (daysBetween(createDate, DateTime.now()) / (60 * 60)).round() < 24 ?
      //Dưới 24 giờ
      "${(daysBetween(createDate, DateTime.now()) / (60 * 60))
          .round()} hours ago" :
      //Trên 24 giờ, đổi sang ngày
      (daysBetween(createDate, DateTime.now()) / (24 * 60 * 60)).round() < 7 ?
      //Dưới 7 ngày
      "${(daysBetween(createDate, DateTime.now()) / (24 * 60 * 60))
          .round()} days ago" :
      //Trên 7 ngày
      DateFormat('dd-MM-yy').format(createDate),
      style: GoogleFonts.readexPro(fontSize: 10, color: Colors.grey),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    return (to
        .difference(from)
        .inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.samplePost.caption);
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
          color: colors.SN_postBackgroundColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildNameAndAttraction(context),
          buildMediasBlock(context),
          buildActionBlock(context),
          widget.samplePost.caption!.isNotEmpty
              ? buildCaptionBlock(context)
              : Container(),
          buildCreateDateBlock(context),
          buildCommentBlock(context)
        ],
      ),
    );
  }
}
