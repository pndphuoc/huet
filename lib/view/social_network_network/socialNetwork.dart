import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/post_model.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'package:hue_t/view/social_network_network/uploading_widget.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import '../../constants/host_url.dart' as url;
import '../../model/user/user.dart';
import '../../providers/tourist_provider.dart';
import 'constants.dart' as constants;
import 'create_post.dart';
import 'package:http/http.dart' as http;

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

  List<String> _fakeDate = [
    "Đại nội Huế",
    "Lăng Minh Mạng",
    "Lăng Đình Trường",
    "Lăng Khải Định",
    "Cung An Định",
    "Ngọ Môn",
    "Nhà Duy Phước"
  ];

  late RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _scrollController = ScrollController();

  final _searchController = TextEditingController();
  var focusNode = FocusNode();
  List<String> _searchResults = [];
  double _containerHeight = 0.0;
  String _selectedAttraction = "Đại nội Huế";
  bool isLoading = true;
  int indexGetPost = 0;
  int indexGetMore = 0;
  bool _showTextField = false;
  static const int postsLimit = 5;

  void _onRefresh() async {
    postList.clear();
    _posts.clear();
    setState(() {
      _morePostsAvailable = true;
    });
    // monitor network fetch
    await _getPosts();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();

    (()async {
      requestStoragePermission();
      var attractionProvider = Provider.of<TouristAttractionProvider>(context, listen: false);
      if(attractionProvider.list.isEmpty) {
        await attractionProvider.getAll();
      }
      _getPosts();
    })();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _posts = [];
  DocumentSnapshot? _lastDocument;
  bool _morePostsAvailable = true;
  List<PostModel> postList = [];
  List<User> userList = [];
  String? idOfThePostJustPosted;

  Future<User> getUser(String userID) async {
    final response = await http.get(
      Uri.parse('${url.url}/api/user/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      return User(
          name: jsonObject['name'],
          mail: jsonObject['email'],
          photoURL: jsonObject['image'],
          uid: jsonObject['_id'],
          password: jsonObject['password'],
          phoneNumber: jsonObject['phone'],
          isGoogle: jsonObject['isGoogle']);
    } else {
      throw Exception("User invalid");
    }
  }

  _getPosts() async {
    postList.clear();
    _posts.clear();
    Query q = _firestore
        .collection('post')
        .where('isDeleted', isEqualTo: false)
        .limit(postsLimit);
    QuerySnapshot querySnapshot = await q.get();
    _posts = querySnapshot.docs;

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }

    for (var e in _posts) {
      postList.add(await PostModel.fromJson(e.data() as Map<String, dynamic>));
      userList.add(await getUser((e.data() as Map<String, dynamic>)["userID"]));
      print(userList.first.name);
    }

    if (idOfThePostJustPosted != null) {
      late var temp;
      for (var e in postList) {
        if (e.postID == idOfThePostJustPosted) {
          temp = e;
          postList.remove(e);
          break;
        }
      }
      postList.indexOf(temp, 0);
    }

    setState(() {
      idOfThePostJustPosted = null;
      isLoading = false;
    });
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
    if (querySnapshot.docs.isEmpty) {
      _morePostsAvailable = false;
      _refreshController.loadComplete();
    }
    if (querySnapshot.docs.length < postsLimit) {
      _morePostsAvailable = false;
    }
    for (var e in querySnapshot.docs) {
      postList.add(await PostModel.fromJson(e.data() as Map<String, dynamic>));
    }
    _posts.addAll(querySnapshot.docs);

    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: colors.primaryColor, size: 30),
          )
        : Scaffold(
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
                        callback: (val) async {
                          idOfThePostJustPosted = val;
                          await _getPosts();
                        },
                        list: constants.postInfomation['medias'],
                        caption: constants.postInfomation['caption'],
                        attractionId:
                            constants.postInfomation['attractionID'].toString(),
                      )
                    : Container(),
                attractionSelector(context),
                Expanded(
                    child: Stack(
                  children: [
                    GestureDetector(
                      onVerticalDragDown: (details) {
                        if (details.localPosition.dy > 0) {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _containerHeight = 0;
                            _showTextField = false;
                          });
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: InViewNotifierCustomScrollView(
                          controller: _scrollController,
                          isInViewPortCondition: (double deltaTop,
                              double deltaBottom, double vpHeight) {
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
                                    itemCount: postList.length,
                                    itemBuilder: (context, index) {
                                      return InViewNotifierWidget(
                                        id: '$index',
                                        builder: (BuildContext context,
                                            bool isInView, Widget? child) {
                                          return isInView
                                              ? Post(
                                                  post: postList[index],
                                                  isInView: true,
                                                  callback: (val) async {
                                                    bool deletePost =
                                                        await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                title: Text(
                                                                  "Delete this post?",
                                                                  style: GoogleFonts.readexPro(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                content: Text(
                                                                  "You can restore this post within 30 days. After that, it will be permanently deleted",
                                                                  style: GoogleFonts
                                                                      .readexPro(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        elevation:
                                                                            0,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                40,
                                                                            right:
                                                                                40,
                                                                            top:
                                                                                15,
                                                                            bottom:
                                                                                15),
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20))),
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: GoogleFonts.readexPro(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                40,
                                                                            right:
                                                                                40,
                                                                            top:
                                                                                15,
                                                                            bottom:
                                                                                15),
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20))),
                                                                    child: const Text(
                                                                        "Delete"),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                    if (deletePost) {
                                                      FirebaseFirestore.instance
                                                          .collection('post')
                                                          .doc(val)
                                                          .update({
                                                        "isDeleted": true
                                                      });
                                                      postList.removeAt(index);
                                                    }
                                                    setState(() {
                                                      //_getPosts();
                                                    });
                                                  },
                                                  user: userList[index],
                                                )
                                              : Post(
                                                  post: postList[index],
                                                  isInView: false,
                                                  callback: (val) async {
                                                    bool deletePost =
                                                        await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return buildDeleteAlertDialog(
                                                                  context);
                                                            });
                                                    if (deletePost) {
                                                      FirebaseFirestore.instance
                                                          .collection('post')
                                                          .doc(val)
                                                          .update({
                                                        "isDeleted": true
                                                      });
                                                    }
                                                    setState(() {
                                                      _getPosts();
                                                    });
                                                  },
                                            user: userList[index],
                                                );
                                        },
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    searchSuggest(context)
                  ],
                )),
/*                AnimatedOpacity(opacity: _showTextField ? 0 : 1, duration: const Duration(milliseconds: 400) , child: const SizedBox(
                  height: 70,
                ),)*/
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
/*                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePost()));*/
                    /*Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          // Use a custom transition animation
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return CreatePost();
                        },
                      ),
                    );*/
                    Navigator.of(context).push(SwipeablePageRoute(
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionBuilder: (context, animation,
                                secondaryAnimation, isSwipeGesture, child) =>
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                        builder: (BuildContext context) => const CreatePost()));
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

  Widget buildDeleteAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Delete this post?",
        style: GoogleFonts.readexPro(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "You can restore this post within 30 days. After that, it will be permanently deleted",
        style: GoogleFonts.readexPro(
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 15, bottom: 15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Text(
            "Cancel",
            style: GoogleFonts.readexPro(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 15, bottom: 15),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: const Text("Delete"),
        ),
      ],
    );
  }

  Widget attractionSelector(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
          color: colors.SN_postBackgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _showTextField ? 0 : 1,
                    child: const Icon(
                      Icons.place_outlined,
                      size: 30,
                    )),
                const SizedBox(
                  width: 10,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showTextField ? 0 : 1,
                  child: GestureDetector(
                    child: Text(
                      _selectedAttraction,
                      style: GoogleFonts.readexPro(
                          fontSize: 15, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: 0,
              bottom: 0,
              left: _showTextField ? 0 : constraints.maxWidth - 60,
              child: SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showTextField = !_showTextField;
                        _showTextField
                            ? _containerHeight = 200
                            : _containerHeight = 0;
                        _searchResults = _fakeDate;
                        _showTextField
                            ? focusNode.requestFocus()
                            : focusNode.unfocus();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: colors.primaryColor,
                        elevation: 0,
                        padding: EdgeInsets.zero),
                    child: const Icon(Icons.search)),
              )),
          Positioned(
            right: 0,
            child: AnimatedContainer(
              width: _showTextField ? constraints.maxWidth - 70 : 0,
              duration: const Duration(milliseconds: 300),
              //padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: constraints.maxWidth - 70,
                child: TextField(
                  focusNode: focusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 20, bottom: 20),
                      hintText: "Search for tourist attractions",
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      suffixIcon: _showTextField
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchResults = [];
                                  _containerHeight = 0;
                                  _searchController.clear();
                                });
                              },
                              child: const Icon(Icons.close),
                            )
                          : Container()),
                  onChanged: (value) {
                    setState(() {
                      _searchResults = _searchAttraction(value);
                      _containerHeight =
                          _calculateContainerHeight(_searchResults.length);
                    });
                  },
                  //enabled: _showTextField ? true : false,
                ),
              ),
            ),
          ),
        ]);
      }),
    );
  }

  Widget searchSuggest(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedContainer(
          decoration: BoxDecoration(
            color: colors.SN_postBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 10.0),
                blurRadius: 16.0,
              ),
            ],
          ),
          margin: const EdgeInsets.only(left: 20, right: 20),
          duration: const Duration(milliseconds: 200),
          height: _containerHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ListView.builder(
              itemExtent: 40,
              itemCount: _searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _selectedAttraction = _searchResults[index];
                      _showTextField = false;
                      _containerHeight = 0;
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _searchResults[index],
                          style: GoogleFonts.readexPro(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<String> _searchAttraction(String value) {
    return _fakeDate
        .where((element) => element.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  double _calculateContainerHeight(int resultCount) {
    // Calculate the height of the container based on the number of search results
    if (resultCount > 5) {
      resultCount = 5;
    }
    return resultCount * 40.0;
  }
}
