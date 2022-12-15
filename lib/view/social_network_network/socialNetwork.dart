import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'package:hue_t/view/social_network_network/uploading_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'constants.dart' as constants;
import 'create_post.dart';


class SocialNetWorkPage extends StatefulWidget {
  const SocialNetWorkPage({Key? key}) : super(key: key);
  @override
  State<SocialNetWorkPage> createState() => _SocialNetWorkPageState();
}

//PostModel samplePost = PostModel(postID: '1', caption: "In the Hue",  userID: 1, attractionID: "1", medias: ["assets/images/socialNetwork/img.png", "assets/images/socialNetwork/img1.png"], likeCount: 69, commentCount: 1, createDate: DateTime(2022, 11, 26), isDeleted: false);

class _SocialNetWorkPageState extends State<SocialNetWorkPage> {
  Future<void> requestStoragePermission() async {
    await Permission.storage.request();
  }

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  static const int postLimit = 10;

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    if(mounted) {
        setState(() {
      });
    }
    _refreshController.loadComplete();
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
  Stream<List<PostModel>> readPosts() => FirebaseFirestore.instance.collection("post").where('isDeleted', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data());
  }).toList());

  @override
  void dispose(){
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: SafeArea(
            child: appBarBlock(context),
          ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropMaterialHeader(backgroundColor: colors.backgroundColor, color: colors.primaryColor,),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              constants.isUploading ? UploadingWidget(list: constants.postInfomation['medias'], caption: constants.postInfomation['caption'],
                attractionId: constants.postInfomation['attractionID'].toString(),) : Container(),
              StreamBuilder<List<PostModel>>(
                  stream: readPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final posts = snapshot.data!;
                      return Column(
                        children: [
                          for(int i=0; i<posts.length; i++)
                            Post(samplePost: posts[i])
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
      ),
    );
  }

  appBarBlock(BuildContext context) {
    return Container(
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
    );
  }
}
