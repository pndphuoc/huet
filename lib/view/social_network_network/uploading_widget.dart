import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:hue_t/colors.dart' as colors;
import 'package:video_compress/video_compress.dart';
import '../../model/social_network/media_model.dart';
import 'constants.dart' as constants;
import 'image_item_widget.dart';

typedef void ResultCallback(bool val);

class UploadingWidget extends StatefulWidget {
  const UploadingWidget({Key? key, required this.list, this.caption, required this.attractionId, required this.callback}) : super(key: key);
  final List<AssetEntity> list;
  final String? caption;
  final String attractionId;
  final ResultCallback callback;
  @override
  State<UploadingWidget> createState() => _UploadingWidgetState();
}

class _UploadingWidgetState extends State<UploadingWidget> {
  UploadTask? uploadTask;
  bool isUploading = false;
  bool isCompressing = false;
  Future<List<Media>> uploadMedia() async {
    setState(() {
      isUploading = true;
    });
    List<Media> mediaList = [];
    const userID = 1;
    for(int i=0; i<widget.list.length; i++){
      final media = await widget.list[i].fileWithSubtype;
      //Nén ảnh

      final type = p.extension(media!.path);
      //Nếu là ảnh thì lưu vào thư mục photos, video thì vào thư mục videos
      late var path;
      File? compressedFile;
      late bool isPhoto;
      if (widget.list[i].type == AssetType.image) {
        //Nén ảnh
        compressedFile = await compressFile(media);
        path = "medias/photos/${userID}-${DateTime.now()}${type}";
        isPhoto = true;
      }
      else {
        setState(() {
          isCompressing = true;
        });
        //Nén video
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          media.path,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: false, // It's false by default
        );
        setState(() {
          isCompressing = false;
        });
        compressedFile = File(mediaInfo!.path!);
        path = "medias/videos/${userID}-${DateTime.now()}${type}";
        isPhoto = false;

      }
      final file = File(compressedFile!.path);
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
    }
    setState(() {
      isUploading = false;
    });
    await VideoCompress.deleteAllCache();
    return mediaList;
  }

  Future<void> uploadPostContent(List<Media> mediaList) async {
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
      likedUsers: [],
      comments: [],
      medias: mediaList,
      postID: docPost.id,
      createDate: DateTime.now()
    );

    final json = post.toJson();
    docPost.set(json);
    FirebaseFirestore.instance.collection('post').doc(docPost.id).collection('comments').doc().set({});
  }

  Future<void> createPost() async {
    await uploadPostContent(await uploadMedia());
    constants.isUploading = false;
    constants.postInfomation = null;
  }

  Future<File?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final type = p.extension(file!.path);
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(type));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_resized${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 75
    );

    print(file.lengthSync());
    print(result?.lengthSync());
    return result;
  }

  @override
  void initState() {
    super.initState();
    createPost();

    widget.callback(true);
  }

  Widget buildUploadingProgress(BuildContext context, double progress) {
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

  Widget buildCompressingProgress(BuildContext context) {
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
          Center(child: Text("Compressing...", style: GoogleFonts.readexPro(color: Colors.black, fontSize: 20),)),
          /*Expanded(
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
          )*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isCompressing ? buildCompressingProgress(context) : isUploading ? StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return buildUploadingProgress(context, progress);
          }
          else {
            return Container();
          }
        }) : Container();
  }
}
