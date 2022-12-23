import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/main.dart';
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import 'package:hue_t/view/social_network_network/search_tourist_attractions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'image_item_widget.dart';
import 'constants.dart' as constants;
import 'package:hue_t/fake_data.dart'as faker;

class CompleteUploadPage extends StatefulWidget {
  const CompleteUploadPage({Key? key, required this.medias}) : super(key: key);
  final List<AssetEntity> medias;

  @override
  State<CompleteUploadPage> createState() => _CompleteUploadPageState();
}

class _CompleteUploadPageState extends State<CompleteUploadPage> {
  int currentPos = 0;
  TouristAttraction? selectedAttraction;
  VideoPlayerController? videoController;
  UploadTask? uploadTask;

  set selected(TouristAttraction value) =>
      setState(() => selectedAttraction = value);
  bool isUploading = false;

  final captionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.medias.first.type == AssetType.video) {
      (() async {
        await loadVideo(widget.medias.first);
      })();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (videoController != null) {
      videoController!.dispose();
    }
  }

  Future<void> loadVideo(AssetEntity entity) async {
    if (entity.type != AssetType.video) {
      return;
    }
    File? file = await entity.file;
    videoController = VideoPlayerController.file(file!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          //Tự động phát video
          videoController!.play();
          videoController?.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: appBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              mediaListBlock(context),
              captionBlock(context),
              selectedAttraction != null
                  ? selectedAttractionBlock(context, selectedAttraction!)
                  : placeSelectorBlock(context),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          if (videoController != null) {
            videoController!.dispose();
          }
          Navigator.pop(context);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title:
          Text("New post", style: GoogleFonts.readexPro(color: Colors.black)),
      actions: [
        IconButton(
            onPressed: () async {
              if (selectedAttraction == null) {
                Fluttertoast.showToast(
                    msg: "Choose a tourist attraction first",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                setState(() {
                  isUploading = true;
                });
                //UploadingWidget(list: widget.medias,);
                constants.isUploading = true;
                constants.postInfomation = {
                  'medias': widget.medias,
                  'caption': captionController.text,
                  'attractionID': selectedAttraction!.id
                };
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const HueT(
                              index: 3,
                            )),
                    (route) => false);
              }
            },
            icon: Icon(
              Icons.check,
              color: colors.primaryColor,
              size: 30,
            ))
      ],
    );
  }

  captionBlock(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colors.SN_postBackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              controller: captionController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: "Write a caption"),
            )),
          ],
        ),
      ),
    );
  }

  mediaListBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider(
              options: CarouselOptions(
                  //height: MediaQuery.of(context).size.height / 2.8,
                  aspectRatio: 1,
                  reverse: false,
                  scrollPhysics: const BouncingScrollPhysics(),
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) async {
                    try {
                      if (videoController != null) {
                        videoController!.dispose();
                      }
                    } catch (e) {
                      print(e);
                    } finally {
                      videoController = null;
                    }
                    setState(() {
                      loadVideo(widget.medias[index]);
                      currentPos = index;
                    });
                  }),
              items: widget.medias.map((e) {
                return Builder(builder: (BuildContext context) {
                  return e.type == AssetType.video
                      ? videoController == null ||
                              !videoController!.value.isInitialized
                          ? Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                  color: colors.primaryColor, size: 30),
                            )
                          : AspectRatio(
                              aspectRatio: videoController!.value.aspectRatio,
                              child: VideoPlayer(videoController!),
                            )
                      : SizedBox(
                          child: ImageItemWidget(
                          entity: e,
                          option: const ThumbnailOption(
                            size: ThumbnailSize.square(1080),
                          ),
                        ));

                  /*if (e.type == AssetType.video){
                    if(videoController != null) {
                      videoController!.dispose();
                    }
                    loadVideo(e);
                    return AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    );
                  }
                  else {
                    if(videoController != null) {
                      videoController!.dispose();
                    }
                    return SizedBox(
                        child: ImageItemWidget(
                          entity: e,
                          option: const ThumbnailOption(
                            size: ThumbnailSize.square(1080),
                          ),
                        ));
                  }*/
                });
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.medias.map((e) {
              int index = widget.medias.indexOf(e);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: currentPos == index ? 20 : 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: currentPos == index
                        ? BoxShape.rectangle
                        : BoxShape.rectangle,
                    borderRadius: currentPos == index
                        ? BorderRadius.circular(8)
                        : BorderRadius.circular(8),
                    color: currentPos == index
                        ? colors.primaryColor
                        : Colors.grey),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  placeBlock(BuildContext context, TouristAttraction att) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: colors.SN_postBackgroundColor,
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: TextButton(
          style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            setState(() {
              selectedAttraction = att;
            });
          },
          child: Text(
            att.title,
            style: GoogleFonts.readexPro(color: Colors.black, fontSize: 13),
          )),
    );
  }

  placeSelectorBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchTouristAttractionPage(
                          callback: (val) => setState(() {
                            selectedAttraction = val;
                          }),
                        ),
                      ));
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add a tourist attraction",
                    style: GoogleFonts.readexPro(
                        fontSize: 20, color: Colors.black),
                  ),
                ))),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(
                width: 20,
              ),
              ...faker.listAttraction.map((e) {
                return placeBlock(context, e);
              }),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        )
      ],
    );
  }

  selectedAttractionBlock(BuildContext context, TouristAttraction att) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: colors.SN_postBackgroundColor,
            //border: Border.all(color: colors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.location_on_rounded,
                      color: colors.primaryColor,
                      size: 20,
                    )),
                    const WidgetSpan(
                        child: SizedBox(
                      width: 10,
                    )),
                    WidgetSpan(
                      child: Text(att.title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.readexPro(
                              fontSize: 20,
                              color: colors.primaryColor,
                              fontWeight: FontWeight.bold)),
                    )
                  ]),
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedAttraction = null;
                  });
                },
                padding: EdgeInsets.zero,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close))
          ],
        ));
  }
}
