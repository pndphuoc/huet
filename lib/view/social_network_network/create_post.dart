import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/social_network_network/grid_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:photo_manager/photo_manager.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'image_item_widget.dart';

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
  Directory directory = Directory('/storage/emulated/0/Pictures');
  bool isScrolled = false;
  bool isMultiSelect = false;
  late AutoScrollController controller;
  bool _loading = false;
  bool isFirstTime = true;
  bool isLoading = true;

  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int _sizePerPage = 50;

  AssetPathEntity? _path;
  List<AssetEntity>? _entities;
  int _totalEntitiesCount = 0;

  int _page = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreToLoad = true;

  Future<void> _requestAssets() async {
    setState(() {
      _isLoading = true;
    });
    // Request permissions.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }
    // Further requests can be only proceed with authorized or limited.
    if (!ps.hasAccess) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Permission is not accessible.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    // Obtain assets using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      hasAll: true,
      onlyAll: true,
      filterOption: _filterOptionGroup,
    );
    if (!mounted) {
      return;
    }
    // Return if not paths found.
    if (paths.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'No paths found.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      _path = paths.first;
    });
    _totalEntitiesCount = await _path!.assetCountAsync;
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities = entities;
      _isLoading = false;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
    });
  }
  Future<void> _loadMoreAsset() async {
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: _page + 1,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities!.addAll(entities);
      _page++;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
      _isLoadingMore = false;
    });
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (_path == null) {
      return const Center(child: Text('Request paths first.'));
    }
    if (_entities?.isNotEmpty != true) {
      return const Center(child: Text('No assets found on this device.'));
    }
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          if (index == _entities!.length - 8 &&
              !_isLoadingMore &&
              _hasMoreToLoad) {
            _loadMoreAsset();
          }
          final AssetEntity entity = _entities![index];
          return ImageItemWidget(
            key: ValueKey<int>(index),
            entity: entity,
            option: const ThumbnailOption(size: ThumbnailSize.square(200)),
          );
        },
        childCount: _entities!.length,
        findChildIndexCallback: (Key key) {
          // Re-use elements.
          if (key is ValueKey<int>) {
            return key.value;
          }
          return null;
        },
      ),
    );
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
    _requestAssets();
  }

  final panelController = PanelController();
  final panelScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "New post",
          style: GoogleFonts.readexPro(color: Colors.black),
        ),
        backgroundColor: colors.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
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
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                controllerBar(context),
                Expanded(child: _buildBody(context))
                //const Expanded(child: GridGallery())
              ],
            )),
          ],
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
                      text: "abc",
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
                      setState(() {});
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
                    onPressed: () {
                      _requestAssets();
                    },
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

/*  Widget imagesGirdView(BuildContext context) {
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
  }*/
}

