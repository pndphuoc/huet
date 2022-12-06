import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/social_network_network/panel.dart';
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
    await Permission.storage.request();
  }

  bool isMultiSelect = false;
  late AutoScrollController controller;
  final panelController = PanelController();
  final panelScrollController = ScrollController();
  VideoPlayerController? videoController;

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
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  AssetEntity? selectedImage;
  List<AssetEntity> selectedList = [];

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
      Fluttertoast.showToast(
          msg: 'Permission is not accessible.',
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
      Fluttertoast.showToast(
          msg: 'No paths found.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      albumList = paths;
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
      selectedAlbum = paths.first;
      selectedImage = entities.first;
      _entities = entities;
      _isLoading = false;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
    });
  }

  Future<void> loadPhotosOfAlbum(AssetPathEntity path) async {
    videoController!.pause();
    final List<AssetEntity> entities = await path.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    _totalEntitiesCount = await path.assetCountAsync;
    setState(() {
      _entities = entities;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
      selectedImage = entities.first;
      loadVideo(selectedImage!);
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                "New post",
                style: GoogleFonts.readexPro(color: Colors.black),
              ),
              backgroundColor: colors.backgroundColor,
              elevation: 0,
            ),
            body: SlidingUpPanel(
              backdropTapClosesPanel: true,
              backdropEnabled: true,
              backdropColor: Colors.black54,
              controller: panelController,
              defaultPanelState: PanelState.CLOSED,
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height / 2,
              panel: panel(panelScrollController, panelController, albumList),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      //height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: (selectedImage?.type == AssetType.video)
                            ? Center(
                                child: videoController!.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            videoController!.value.aspectRatio,
                                        child: VideoPlayer(videoController!),
                                      )
                                    : Container(),
                              )
                            : ImageItemWidget(
                                entity: selectedImage!,
                                option: const ThumbnailOption(
                                  size: ThumbnailSize(1080, 1080),
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        controllerBar(context),
                        Expanded(child: imagesGrid(context))
                        //const Expanded(child: GridGallery())
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> loadVideo(AssetEntity entity) async {
    if (entity.type == AssetType.video) {
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
  }

  Widget imagesGrid(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (_path == null) {
      return const Center(child: Text('Request paths first.'));
    }
    if (_entities?.isNotEmpty != true) {
      return const Center(child: Text('No assets found on this device.'));
    }
    return GridView.builder(
      scrollDirection: Axis.vertical,
      controller: controller,
      cacheExtent: 9999,
      itemCount: _entities!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 1),
      itemBuilder: (context, index) {
        if (index == _entities!.length - 8 &&
            !_isLoadingMore &&
            _hasMoreToLoad) {
          _loadMoreAsset();
        }
        final AssetEntity entity = _entities![index];
        return AutoScrollTag(
          key: ValueKey(index),
          controller: controller,
          index: index,
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                //Chuyến sang chế độ MultiSelect nếu =false khi nhấn giữ
                if (isMultiSelect == false) {
                  selectedList.clear();
                  selectedImage = entity;
                  selectedList.add(entity);
                  isMultiSelect = true;
                }
              });
            },
            onTap: () async {
              //Nếu file được chọn là Video
             /* if (entity.type == AssetType.video) {
                File? file = await entity.file;
                videoController = VideoPlayerController.file(file!)
                  ..initialize().then((_) {
                    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                    setState(() {
                      //Tự động phát video
                      videoController.play();
                    });
                  });
              }*/
              await loadVideo(entity);
              //nếu chọn mục khác video sẽ dừng

              //Thực hiện các thao tác khác
              setState(() {
                if(videoController != null)
                  {
                    videoController!.pause();
                  }
                selectedImage = entity;
                if (isMultiSelect) {
                  if (selectedList.contains(entity)) {
                    selectedList.remove(entity);
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
                      selectedList.add(entity);
                    }
                  }
                }
                else {
                  controller.scrollToIndex(index,
                      preferPosition: AutoScrollPosition.begin);
                }
              });
            },
            child: isMultiSelect == false
                ? Opacity(
                    opacity: entity == selectedImage ? 0.5 : 1,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: ImageItemWidget(
                          key: ValueKey<int>(index),
                          entity: entity,
                          option: const ThumbnailOption(
                            size: ThumbnailSize.square(200),
                          ),
                        )),
                  )
                : Stack(
                    children: [
                      Opacity(
                          opacity: selectedImage == entity ? 0.5 : 1,
                          child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: ImageItemWidget(
                                key: ValueKey<int>(index),
                                entity: entity,
                                option: const ThumbnailOption(
                                  size: ThumbnailSize.square(200),
                                ),
                              ))),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              shape: BoxShape.circle,
                              color:
                                  isMultiSelect && selectedList.contains(entity)
                                      ? colors.primaryColor
                                      : Colors.white54),
                          height: 20,
                          width: 20,
                          child: isMultiSelect && selectedList.contains(entity)
                              ? Center(
                                  child: Text(
                                  "${selectedList.indexOf(entity) + 1}",
                                  style: const TextStyle(color: Colors.white),
                                ))
                              : null,
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
      findChildIndexCallback: (Key key) {
        // Re-use elements.
        if (key is ValueKey<int>) {
          return key.value;
        }
        return null;
      },
    );
  }

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
                        selectedList.clear();
                        isMultiSelect = !isMultiSelect;
                        selectedList.add(selectedImage!);
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

  Widget panel(ScrollController panelScrollController,
      PanelController panelController, List<AssetPathEntity> albums) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      child: Column(children: [
        Center(
          child: Icon(
            Icons.minimize_rounded,
            size: 30,
            color: colors.primaryColor,
          ),
        ),
        Expanded(
            child: ListView(
          controller: panelScrollController,
          children: [
            ...albums.map(
              (e) => TextButton(
                  onPressed: () {
                    panelController.close();
                    setState(() {
                      selectedAlbum = e;
                      loadPhotosOfAlbum(e);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: double.infinity,
                    child: Text(
                      e.name ?? "Untitled",
                      style: GoogleFonts.readexPro(
                          color: Colors.black, fontSize: 20),
                    ),
                  )),
            ),
          ],
        ))
      ]),
    );
  }
}
