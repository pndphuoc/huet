import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
  }

  ScrollController _singChildController = ScrollController();
  ScrollController _gridViewController = ScrollController();

  late String selectedImage;
  late List<String> imageList;
  late Directory directory;
  late ScrollController _controller;
  bool isScrolled = false;

  _scrollListener() {
    if (_controller.offset == _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        isScrolled = false;
      });
    }
    if (_controller.offset > _controller.position.minScrollExtent - 50 &&
        !_controller.position.outOfRange) {
      setState(() {
        isScrolled = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    requestStoragePermission();
    directory = Directory('/storage/emulated/0/Pictures/AdobeLightroom');
    List<String> extensionList = ['.jpg', '.png'];
    imageList = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => extensionList.any((element) => item.endsWith(element)))
        .toList(growable: false);
    selectedImage = imageList.first;
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
                child: imagesGridView(context, imageList)),

          ],
        ),
      ),
    );
  }

  Widget imagesGridView(BuildContext context, List<String> imageList) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        print("phuoc");
      },
      child: GridView.builder(
          cacheExtent: 9999,
          itemCount: imageList.length,
          controller: _controller,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1),
          itemBuilder: (context, index) {
            return Opacity(
                opacity: selectedImage == imageList[index] ? 0.5 : 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = imageList[index];
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Image(
                        image: ResizeImage(FileImage(File(imageList[index])), width: 175),
                        fit: BoxFit.cover,
                      )),
                ));
          }),
    );
  }
}
