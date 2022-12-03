import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:scroll_to_index/scroll_to_index.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
  }

  String selectedImage = '';
  List<File> imageFileList = [];
  List<String> imageList = [];
  Directory directory = Directory('/storage/emulated/0/Pictures');
  bool isScrolled = false;
  bool isMultiSelect = false;
  List<String> selectedList = [];
  late AutoScrollController controller;

/*  List<String> getAllPhoto(Directory dirPath) {
    List contents = dirPath.listSync();
    bool isExistSubDir = false;
    List<String> extensionList = ['.jpg', '.png'];
    List<String> imageList = dirPath.listSync().map((item) => item.path)
        .where((item) => extensionList.any((element) => item.endsWith(element)))
        .toList(growable: false);

    for(var dir in contents) {
      if(dir is Directory) {
        imageList += getAllPhoto(dir);
        isExistSubDir = true;
      }
    }
    return imageList;
  }*/

  Future<void> getAllPhoto(Directory dir) async {
    List<String> extensionList = ['.jpg', '.png'];
    await for (var entity in
    dir.list(recursive: true, followLinks: false).map((e) => e).where((item) => extensionList.any((element) => item.path.endsWith(element)))) {
      if (entity is File) {
        imageFileList.add(entity);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    requestStoragePermission();



    List contents = directory.listSync();
    List<String> dirList = [];
    for (var fileOrDir in contents) {
      if (fileOrDir is Directory) {
        dirList.add(fileOrDir.path);
      }
    }

    List<String> extensionList = ['.jpg', '.png'];
    imageList = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => extensionList.any((element) => item.endsWith(element)))
        .toList(growable: false);
    getAllPhoto(directory).whenComplete(() {
      setState(() {
      });
      imageFileList.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      imageList = imageFileList.map((e) => e.path).toList();
      selectedImage = imageList.first;
    });
    /*(() async {
      await getAllPhoto(directory);
    })();*/


    //selectedList.first = imageList.first;
  }

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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(selectedImage)),
                          fit: BoxFit.fitWidth)),
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                controllerBar(context),
                Expanded(child: imagesGridView(context, imageList))
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget imagesGridView(BuildContext context, List<String> imageList) {
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
                  if(selectedList.contains(imageList[index])) {
                    selectedList.remove(imageList[index]);
                  }
                  else {
                    if(selectedList.length>=10) {
                      Fluttertoast.showToast(
                          msg: "Limited to 10 photos or videos",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else {
                      controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
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
                          image: ResizeImage(FileImage(File(imageList[index])),
                              width: 140),
                          fit: BoxFit.cover,
                        )),
                  )
                  : Stack(
                      children: [
                        Opacity(opacity: selectedImage == imageList[index] ? 0.5 : 1,
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
                            )),),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 1),
                                  shape: BoxShape.circle,
                                  color: isMultiSelect&&selectedList.contains(imageList[index])?colors.primaryColor:Colors.white54),
                              height: 20,
                              width: 20,
                              child: isMultiSelect&&selectedList.contains(imageList[index])?Center(child: Text("${selectedList.indexOf(imageList[index]) + 1}", style: TextStyle(color: Colors.white),)):null,
                            ),
                        )
                      ],
                    ),
            ),
          );
        });
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
              onPressed: () {},
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                overlayColor: MaterialStatePropertyAll(Colors.transparent)
              ),
              child: RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      text: "Thư viện",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  WidgetSpan(
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
                        if(isMultiSelect)
                          {
                            selectedList.clear();
                            selectedList.add(selectedImage);
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
}
