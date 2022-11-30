import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hue_t/colors.dart' as colors;

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
  }

  Future<void> selectMultiFile() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    print(images?.length.toString());
  }
  @override
  void initState()  {
    super.initState();
    requestStoragePermission();
    //selectMultiFile();
  }

  final Directory directory = new Directory('/storage/emulated/0/Pictures/AdobeLightroom');
  String selectedImage = '';
  bool isScrolled = false;
  @override
  Widget build(BuildContext context) {
    List<String> extensionList = ['.jpg', '.png'];
    var imageList = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => extensionList.any((element) => item.endsWith(element)))
        .toList(growable: false);

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
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: isScrolled?0: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(selectedImage)),
                    fit: BoxFit.fitWidth
                  )
                ),
              ),
              Expanded(child: imagesGridView(context, imageList))
            ],
          )
        ),
      ),
    );
  }
  
  Widget imagesGridView(BuildContext context, List<String> imageList) {
    return GridView.count(crossAxisCount: 3,
      children: [
        ...imageList.map((e) => GestureDetector(
                onTap: (){
                  setState(() {
                    selectedImage = e;
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    isScrolled = !isScrolled;
                  });
                },
                child: Opacity(
                    opacity: selectedImage == e? 0.5:1,
                    child: Image.file(File(e), scale: 1, fit: BoxFit.cover,))))
      ],
    );
  }
}
