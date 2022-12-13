import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:hue_t/colors.dart' as colors;
import '../../model/social_network/media_model.dart';
import 'constants.dart' as constants;
import 'image_item_widget.dart';

class UploadingWidget extends StatefulWidget {
  const UploadingWidget({Key? key, required this.list, this.caption, required this.attractionId}) : super(key: key);
  final List<AssetEntity> list;
  final String? caption;
  final String attractionId;
  @override
  State<UploadingWidget> createState() => _UploadingWidgetState();
}

class _UploadingWidgetState extends State<UploadingWidget> {
  UploadTask? uploadTask;
  bool isUploading = false;
  Future<List<Media>> uploadMedia() async {
    setState(() {
      isUploading = true;
    });
    List<Media> mediaList = [];
    const userID = 1;
    for(int i=0; i<widget.list.length; i++){
      final media = await widget.list[i].fileWithSubtype;
      final type = p.extension(media!.path);
      //Nếu là ảnh thì lưu vào thư mục photos, video thì vào thư mục videos
      late var path;
      late bool isPhoto;
      if (widget.list[i].type == AssetType.image) {
        path = "medias/photos/${userID}-${DateTime.now()}${type}";
        isPhoto = true;
      } else {
        path = "medias/videos/${userID}-${DateTime.now()}${type}";
        isPhoto = false;
      }
      final file = File(media!.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();


      mediaList.add(Media(url: urlDownload, isPhoto: isPhoto));
      setState(() {
        uploadTask = null;
      });
      print(urlDownload);
    }
    setState(() {
      isUploading = false;
    });
    return mediaList;
  }

  Future uploadPostContent(List<Media> mediaList) async {
/*    List<Object> mediaJson = [];
    for (int i=0 ; i<mediaList.length; i++) {
      mediaJson.add(mediaList[i].toJson());
    }*/

    final docPost = FirebaseFirestore.instance.collection('post').doc();
    final post = PostModel(
      attractionID: widget.attractionId,
      userID: 1,
      caption: widget.caption!,
      isDeleted: false,
      likeCount: 0,
      commentCount: 0,
      medias: mediaList,
      postID: docPost.id,
      createDate: DateTime.now()
    );

    final json = post.toJson();
    return docPost.set(json);
  }

  Future<void> createPost() async {
    await uploadPostContent(await uploadMedia());
    constants.isUploading = false;
    constants.postInfomation = null;
  }
  @override
  void initState() {
    super.initState();
    createPost();
  }

  @override
  Widget build(BuildContext context) {
    return isUploading ? StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return Container(
              height: 60,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: colors.SN_postBackgroundColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ImageItemWidget(
                      entity: widget.list.first,
                      option: const ThumbnailOption(
                        size: ThumbnailSize.square(200),
                      ),
                  ),
                    ),),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Uploading...", style: GoogleFonts.readexPro(color: Colors.black, fontSize: 15),),
                        const SizedBox(height: 10,),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey,
                          color: colors.primaryColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          else {
            return Container();
          }
        }) : Container();
  }
}
