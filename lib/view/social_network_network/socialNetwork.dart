import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post.dart';
import 'create_post_2.dart';
import 'simple_example_page.dart' as cp2;

import 'create_post.dart';


class SocialNetWorkPage extends StatefulWidget {
  const SocialNetWorkPage({Key? key}) : super(key: key);

  @override
  State<SocialNetWorkPage> createState() => _SocialNetWorkPageState();
}

PostModel samplePost = PostModel(postID: 1, content: "In the Hue",  userID: 1, placeID: 1, photos: ["assets/images/socialNetwork/img.png", "assets/images/socialNetwork/img1.png"], likeCount: 69, commentCount: 1, createDate: DateTime(2022, 11, 26), isDeleted: false);

class _SocialNetWorkPageState extends State<SocialNetWorkPage> {
  List<Widget> postsList = [
    Post(samplePost: samplePost),
    Post(samplePost: samplePost),
    Post(samplePost: samplePost),
  ];

  late NavigatorState _navigator;
  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 70,),
                  for(var item in postsList)
                    item,
                  SizedBox(height: 80,)
                ],
              ),
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
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("Huegram", style: GoogleFonts.montserrat(color: Colors.black, fontSize: 25),),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  ElevatedButton(onPressed: (){}, child: Icon(Icons.notifications_outlined, size: 20, color: Colors.black,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: colors.SN_circleButton,
                      elevation: 0,
                      minimumSize: Size(45, 45)
                    ),

                  ),
                  ElevatedButton(onPressed: (){
                   Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const CreatePost()));
                  }, child: Icon(Icons.add_circle_outline, size: 20, color: Colors.black,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: colors.SN_circleButton,
                      elevation: 0,
                        minimumSize: Size(45, 45)
                    ),
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
