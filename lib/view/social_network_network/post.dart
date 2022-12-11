import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/heart_animation.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post_comments.dart';

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
  int currentPos = 0;
  bool isLiked = false;
  bool isHeartAnimating = false;
  bool isHeartButtonAnimating = false;
  bool isMark = false;

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: colors.SN_postBackgroundColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 50,
                    width: 50,
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                          "assets/images/socialNetwork/jennieAvatar.png"),
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
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
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
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
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
                  CarouselSlider(
                    options: CarouselOptions(
                        //height: MediaQuery.of(context).size.height / 2.8,
                        aspectRatio: 1,
                        reverse: false,
                        scrollPhysics: const BouncingScrollPhysics(),
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentPos = index;
                          });
                        }),
                    items: widget.samplePost.photos.map((e) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: Image.asset(
                              e,
                              width: double.infinity,
                            ));
                      });
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 1,
                    right: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.samplePost.photos.map((e) {
                        int index = widget.samplePost.photos.indexOf(e);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: currentPos == index ? 20 : 8.0,
                          height: 8.0,
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
                          onEnd: () =>
                              setState(() => isHeartAnimating = false),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HeartAnimation(
                    isAnimating:
                        isHeartButtonAnimating || isHeartAnimating, ////
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                          isHeartButtonAnimating =
                              !isHeartButtonAnimating;
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
                  Text(
                    "4k",
                    style: GoogleFonts.readexPro(
                      color: colors.SN_postTextColor,
                      fontSize: 15,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostCommentsPage(
                                    post: widget.samplePost,
                                  )));
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(
                      Icons.mode_comment_outlined,
                      size: 25,
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  Text(
                    "2.1k",
                    style: GoogleFonts.readexPro(
                      color: colors.SN_postTextColor,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              IconButton(
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
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                widget.samplePost.content,
                style: GoogleFonts.readexPro(color: Colors.black),
              )),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
          )
        ],
      ),
    );
  }
}
