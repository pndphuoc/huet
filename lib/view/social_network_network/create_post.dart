import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/social_network_network/panel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:photo_gallery/photo_gallery.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

Medium? selectedImage;

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
  }

  List<File> imageFileList = [];
  List<String> imageList = [];
  Directory directory = Directory('/storage/emulated/0/Pictures/');
  bool isScrolled = false;
  bool isMultiSelect = false;
  List<Medium> selectedList = [];
  late AutoScrollController controller;
  Album? selectedAlbum;
  late List<Album> _albums;
  bool _loading = false;
  bool isFirstTime = true;
  List<Medium>? _media;
  bool isLoading = true;

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      setState(() {
        _albums = albums;
        _loading = false;
        selectedAlbum = _albums.first;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  void initAsyncMedia() async {
    if(isFirstTime) {
      await initAsync();
        setState(() {
          isFirstTime = false;
        });
    }
    MediaPage mediaPage = await selectedAlbum!.listMedia();
    setState(() {
      _media = mediaPage.items;
      isLoading = false;
      selectedImage = _media!.first;
    });
  }

  void initAsyncMediaAlbum(Album album) async {
    MediaPage mediaPage = await album.listMedia();
    setState(() {
      _media = mediaPage.items;
      isLoading = false;
      selectedImage = _media!.first;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    requestStoragePermission();
    //initAsync();
    initAsyncMedia();
  }

  final panelController = PanelController();
  final panelScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: colors.primaryColor, size: 50),
          )
        : Scaffold(
            body: SafeArea(
              child: SlidingUpPanel(
                borderRadius: BorderRadius.circular(20),
                color: colors.SN_panelBackgroundColor,
                defaultPanelState: PanelState.CLOSED,
                controller: panelController,
                minHeight: 0,
                snapPoint: 0.5,
                maxHeight: MediaQuery.of(context).size.height,
                backdropEnabled: true,
                backdropColor: Colors.black54,
                panelBuilder: (controller) {
                  return Panel(
                    controller: panelScrollController,
                    panelController: panelController,
                    albums: _albums,
                    callback: (value) {
                      setState(() {
                        selectedAlbum = value;
                        initAsyncMedia();
                      });
                    },
                  );
                },
                body: Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: Colors.black),
                    title: Text(
                      "New post",
                      style: GoogleFonts.readexPro(color: Colors.black),
                    ),
                    backgroundColor: colors.backgroundColor,
                    elevation: 0,
                  ),
                  body: Column(
                    children: [
                      SizedBox(
                        //height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            /*decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(File(selectedImage)),
                              fit: BoxFit.fitWidth)),*/
                            child: selectedImage != null
                                ? FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: MemoryImage(kTransparentImage),
                                    image: PhotoProvider(
                                      mediumId: selectedImage!.id,
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          controllerBar(context),
                          //Expanded(child: imagesGridView(context, imageList))
                          Expanded(
                              //child: AlbumPage(selectedAlbum!, key: UniqueKey(), isMultiSelect: isMultiSelect))
                              child: imagesGirdView(context)),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

/*  Widget imagesGridView(BuildContext context, List<String> imageList) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        controller: controller,
        cacheExtent: 9999,
        itemCount: imageList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1),
        itemBuilder: (context, index) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: controller,
            index: index,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedImage = imageList[index];
                  if (selectedList.contains(imageList[index])) {
                    selectedList.remove(imageList[index]);
                  } else {
                    if (selectedList.length >= 10) {
                      Fluttertoast.showToast(
                          msg: "Limited to 10 photos or videos",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      controller.scrollToIndex(index,
                          preferPosition: AutoScrollPosition.begin);
                      selectedList.add(imageList[index]);
                    }
                  }
                });
              },
              child: isMultiSelect == false
                  ? Opacity(
                      opacity: selectedImage == imageList[index] ? 0.5 : 1,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                          child: Image(
                            image: ResizeImage(
                                FileImage(File(imageList[index])),
                                width: 140),
                            fit: BoxFit.cover,
                          )),
                    )
                  : Stack(
                      children: [
                        Opacity(
                            opacity:
                                selectedImage == imageList[index] ? 0.5 : 1,
                            child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                ),
                                child: Image(
                                  image: ResizeImage(
                                      FileImage(File(imageList[index])),
                                      width: 140),
                                  fit: BoxFit.cover,
                                ))),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                shape: BoxShape.circle,
                                color: isMultiSelect &&
                                        selectedList.contains(imageList[index])
                                    ? colors.primaryColor
                                    : Colors.white54),
                            height: 20,
                            width: 20,
                            child: isMultiSelect &&
                                    selectedList.contains(imageList[index])
                                ? Center(
                                    child: Text(
                                    "${selectedList.indexOf(imageList[index]) + 1}",
                                    style: const TextStyle(color: Colors.white),
                                  ))
                                : null,
                          ),
                        )
                      ],
                    ),
            ),
          );
        });
  }*/

  Widget controllerBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 50,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                panelController.open();
              },
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  overlayColor: MaterialStatePropertyAll(Colors.transparent)),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: selectedAlbum!.name,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 20)),
                  const WidgetSpan(
                      child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ))
                ]),
              )),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isMultiSelect
                        ? colors.primaryColor
                        : const Color.fromARGB(255, 172, 173, 168)),
                child: IconButton(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        isMultiSelect = !isMultiSelect;
                        if (isMultiSelect) {
                          selectedList.clear();
                          //selectedList.add(selectedImage);
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.layers_outlined,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 172, 173, 168)),
                child: IconButton(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imagesGirdView(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        controller: controller,
        cacheExtent: 9999,
        itemCount: _media!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1),
        itemBuilder: (context, index) {
          return AutoScrollTag(
            key: ValueKey(index),
            controller: controller,
            index: index,
            child: isMultiSelect == false
                  ? GestureDetector(
              onTap: (){
                setState(() {
                  selectedImage = _media![index];
                });
              },
                    child: Container(
                        color: Colors.grey[300],
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: ThumbnailProvider(
                            mediumId: _media![index].id,
                            mediumType: _media![index].mediumType,
                            highQuality: true,
                          ),
                        ),
                      ),
                  )
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImage = _media![index];
                    if (!selectedList.contains(_media![index])) {
                      if (selectedList.length >= 10) {
                        Fluttertoast.showToast(
                            msg: "Limited to 10 photos or videos",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        controller.scrollToIndex(index,
                            preferPosition: AutoScrollPosition.begin);
                        selectedList.add(_media![index]);
                      }
                    } else {
                      selectedList.remove(_media![index]);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[300],
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: MemoryImage(kTransparentImage),
                        image: ThumbnailProvider(
                          mediumId: _media![index].id,
                          mediumType: _media![index].mediumType,
                          highQuality: true,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.white, width: 1),
                            shape: BoxShape.circle,
                            color: isMultiSelect &&
                                selectedList.contains(_media![index])
                                ? colors.primaryColor
                                : Colors.white54),
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Text(selectedList.contains(_media![index])
                              ? "${selectedList.indexOf(_media![index]) + 1}"
                              : ""),
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        });
  }
}

class AlbumPage extends StatefulWidget {
  final Album album;
  final bool isMultiSelect;

  //final Function selectedImage;
  const AlbumPage(this.album, {Key? key, required this.isMultiSelect})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  List<Medium>? _media;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    MediaPage mediaPage = await widget.album.listMedia();
    setState(() {
      _media = mediaPage.items;
    });
  }

  List<Medium> selectedList = [];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: <Widget>[
        ...?_media?.map(
          (medium) => GestureDetector(
            onTap: () {
              setState(() {
                selectedImage = medium;
                if (!selectedList.contains(medium)) {
                  selectedList.add(medium);
                } else {
                  selectedList.remove(medium);
                }
              });
            },
            child: widget.isMultiSelect == false
                ? Container(
                    color: Colors.grey[300],
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: ThumbnailProvider(
                        mediumId: medium.id,
                        mediumType: medium.mediumType,
                        highQuality: true,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[300],
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: ThumbnailProvider(
                            mediumId: medium.id,
                            mediumType: medium.mediumType,
                            highQuality: true,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              shape: BoxShape.circle,
                              color: widget.isMultiSelect &&
                                      selectedList.contains(medium)
                                  ? colors.primaryColor
                                  : Colors.white54),
                          height: 20,
                          width: 20,
                          child: Center(
                            child: Text(selectedList.contains(medium)
                                ? "${selectedList.indexOf(medium) + 1}"
                                : ""),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
