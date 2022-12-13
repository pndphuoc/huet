import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'package:hue_t/view/social_network_network/uploading_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../provider/social_network/posts_provider.dart';

import 'create_post.dart';


class SocialNetWorkPage extends StatefulWidget {
  const SocialNetWorkPage({Key? key, this.list, this.caption, this.attractionId}) : super(key: key);
  final List<AssetEntity>? list;
  final String? caption;
  final int? attractionId;
  @override
  State<SocialNetWorkPage> createState() => _SocialNetWorkPageState();
}

PostModel samplePost = PostModel(postID: '1', caption: "In the Hue",  userID: 1, attractionID: "1", medias: ["assets/images/socialNetwork/img.png", "assets/images/socialNetwork/img1.png"], likeCount: 69, commentCount: 1, createDate: DateTime(2022, 11, 26), isDeleted: false);

class _SocialNetWorkPageState extends State<SocialNetWorkPage> {
  List<Widget> postsList = [
    Post(samplePost: samplePost),
    Post(samplePost: samplePost),
    Post(samplePost: samplePost),
  ];
  Future<void> requestStoragePermission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  Stream<List<PostModel>> readPosts() => FirebaseFirestore.instance.collection("post")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        PostModel post = PostModel.fromJson(doc.data());
        return PostModel.fromJson(doc.data());
  }).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70,),
                widget.list != null ? UploadingWidget(list: widget.list!, caption: widget.caption??"",
                  attractionId: widget.attractionId.toString(),) : Container(),
                StreamBuilder<List<PostModel>>(
                  stream: readPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final posts = snapshot.data!;
                        return Column(
                          children: [

                          ],
                        );
                      }
                      else {
                        return Container();
                      }
                    }
                ),
                const SizedBox(height: 80,),
              ],
            ),
          ),
            appBarBlock(context),
          ]
        ),
      ),
    );
  }

  appBarBlock(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 70,
        color: colors.backgroundColor,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text("Huegram", style: GoogleFonts.montserrat(color: Colors.black, fontSize: 25),),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: colors.SN_circleButton,
                      elevation: 0,
                      minimumSize: const Size(45, 45)
                    ), child: const Icon(Icons.notifications_outlined, size: 20, color: Colors.black,),

                  ),
                  ElevatedButton(onPressed: (){
                   Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const CreatePost()));
                  },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: colors.SN_circleButton,
                      elevation: 0,
                        minimumSize: const Size(45, 45)
                    ), child: const Icon(Icons.add_circle_outline, size: 20, color: Colors.black,),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
