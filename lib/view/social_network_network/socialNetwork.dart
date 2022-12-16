import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'package:hue_t/view/social_network_network/uploading_widget.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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

  late RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  static const int postsLimit = 2;

  void _onRefresh() async {
    _posts.clear();
    setState(() {
      _morePostsAvailable = true;
    });
    // monitor network fetch
    await _getPosts();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _getPosts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _posts = [];
  DocumentSnapshot? _lastDocument;
  bool _morePostsAvailable = true;

  _getPosts() async {
    Query q = _firestore
        .collection('post')
        .where('isDeleted', isEqualTo: false)
        .limit(postsLimit);
    QuerySnapshot querySnapshot = await q.get();
    _posts = querySnapshot.docs;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {});
  }

  _getMorePosts() async {
    if (_morePostsAvailable == false) {
      _refreshController.loadComplete();
      return;
    }

    Query q = _firestore
        .collection('post')
        .where('isDeleted', isEqualTo: false)
        .startAfterDocument(_posts.last)
        .limit(postsLimit);

    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length == 0) {
      _morePostsAvailable = false;
      _refreshController.loadComplete();
    }
    if (querySnapshot.docs.length < postsLimit) {
      _morePostsAvailable = false;
    }

    _lastDocument = querySnapshot.docs.last;
    _posts.addAll(querySnapshot.docs);

    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  Card buildButton({
    required onTap,
    required title,
    required text,
    required leadingImage,
  }) {
    return Card(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: AssetImage(
            leadingImage,
          ),
        ),
        title: Text(title ?? ""),
        subtitle: Text(text ?? ""),
        trailing: const Icon(
          Icons.keyboard_arrow_right_rounded,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: SafeArea(
          child: appBarBlock(context),
        ),
      ),
      body: Column(
        children: [
          constants.isUploading
              ? UploadingWidget(
                  callback: (val) {
                    _getPosts();
                  },
                  list: constants.postInfomation['medias'],
                  caption: constants.postInfomation['caption'],
                  attractionId:
                      constants.postInfomation['attractionID'].toString(),
                )
              : Container(),
          Expanded(
              child: InViewNotifierCustomScrollView(
            isInViewPortCondition:
                (double deltaTop, double deltaBottom, double vpHeight) {
              return deltaTop < (0.5 * vpHeight) &&
                  deltaBottom > (0.5 * vpHeight);
            },
            slivers: [
              SliverFillRemaining(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropMaterialHeader(
                    backgroundColor: colors.backgroundColor,
                    color: colors.primaryColor,
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _morePostsAvailable
                      ? _getMorePosts
                      : () {
                          _refreshController.loadComplete();
                        },
                  child: ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        return InViewNotifierWidget(
                          id: '$index',
                          builder: (BuildContext context, bool isInView,
                              Widget? child) {
                            PostModel post = PostModel.fromJson(
                              _posts[index].data()
                              as Map<String, dynamic>,
                            );
                            return isInView
                                ? Post(
                                    samplePost: post,
                                    isInView: true,
                                    documentSnapshot: _posts[index],
                                    callback: (val) async {
                                       bool deletePost = await showDialog(
                                           context: context,
                                           builder: (BuildContext context) {
                                             return AlertDialog(
                                               shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(20)
                                               ),
                                               title: Text("Delete this post?", style: GoogleFonts.readexPro(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center,),
                                               content: Text("You can restore this post within 30 days. After that, it will be permanently deleted", style: GoogleFonts.readexPro(color: Colors.grey,), textAlign: TextAlign.center,),
                                               actionsAlignment: MainAxisAlignment.center,
                                               actions: [
                                                 ElevatedButton(onPressed: (){
                                                   Navigator.of(context).pop(false);
                                                 },
                                                   style: ElevatedButton.styleFrom(
                                                     elevation: 0,
                                                       padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
                                                       backgroundColor: Colors.white,
                                                       shape: RoundedRectangleBorder(
                                                           borderRadius: BorderRadius.circular(20)
                                                       )
                                                   ), child: Text("Cancel", style: GoogleFonts.readexPro(color: Colors.grey),),
                                                 ),
                                                 ElevatedButton(onPressed: (){
                                                   Navigator.of(context).pop(true);
                                                 },
                                                   style: ElevatedButton.styleFrom(
                                                     padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
                                                     backgroundColor: Colors.red,
                                                     shape: RoundedRectangleBorder(
                                                       borderRadius: BorderRadius.circular(20)
                                                     )
                                                   ), child: const Text("Delete"),
                                                 ),
                                               ],
                                             );
                                           }
                                       );
                                       if(deletePost) {
                                         FirebaseFirestore.instance.collection('post').doc(val).update(
                                             {"isDeleted": true});
                                       }
                                       setState(() {
                                         _getPosts();
                                       });
                                    },
                                  )
                                : Post(
                                    samplePost: post,
                                    isInView: false,
                                    documentSnapshot: _posts[index],
                              callback: (val) async {
                                bool deletePost = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        title: Text("Delete this post?", style: GoogleFonts.readexPro(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center,),
                                        content: Text("You can restore this post within 30 days. After that, it will be permanently deleted", style: GoogleFonts.readexPro(color: Colors.grey,), textAlign: TextAlign.center,),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(onPressed: (){
                                            Navigator.of(context).pop(false);
                                          },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20)
                                                )
                                            ), child: Text("Cancel", style: GoogleFonts.readexPro(color: Colors.grey),),
                                          ),
                                          ElevatedButton(onPressed: (){
                                            Navigator.of(context).pop(true);
                                          },
                                            style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20)
                                                )
                                            ), child: const Text("Delete"),
                                          ),
                                        ],
                                      );
                                    }
                                );
                                if(deletePost) {
                                  FirebaseFirestore.instance.collection('post').doc(val).update(
                                      {"isDeleted": true});
                                }
                                setState(() {
                                  _getPosts();
                                });
                              },
                                  );
                          },
                        );
                      }),
                ),
              )
            ],
          )),
          const SizedBox(
            height: 70,
          )
        ],
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
            child: Text(
              "Huegram",
              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 25),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: colors.SN_circleButton,
                      elevation: 0,
                      minimumSize: const Size(45, 45)),
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePost()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: colors.SN_circleButton,
                      elevation: 0,
                      minimumSize: const Size(45, 45)),
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
