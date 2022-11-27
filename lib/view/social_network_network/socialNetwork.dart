import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/social_network/postModel.dart';
import 'package:hue_t/view/social_network_network/post.dart';

class SocialNetWorkPage extends StatefulWidget {
  const SocialNetWorkPage({Key? key}) : super(key: key);

  @override
  State<SocialNetWorkPage> createState() => _SocialNetWorkPageState();
}

PostModel samplePost = PostModel(postID: 1, content: "In the Hue",  userID: 1, placeID: 1, photos: ["assets/images/socialNetwork/img.png", "assets/images/socialNetwork/img1.png"], likeCount: 69, createDate: DateTime(2022, 11, 26), isDeleted: false);

class _SocialNetWorkPageState extends State<SocialNetWorkPage> {
  List<Widget> postsList = [
    Post(samplePost: samplePost),
    Post(samplePost: samplePost),
    Post(samplePost: samplePost),
  ];

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
                  ElevatedButton(onPressed: (){}, child: Icon(Icons.add_circle_outline, size: 20, color: Colors.black,),
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


 /* postBlock(BuildContext context) {
    int currentPos = 0;
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colors.SN_postBackgroundColor,
        borderRadius: BorderRadius.circular(30)
      ),
      child: Container(
        //padding: EdgeInsets.only(top: 15, left: 15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 50,
                      width: 50,
                      child: CircleAvatar(
                        backgroundImage:
                        AssetImage("assets/images/socialNetwork/jennieAvatar.png"),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("jennierubyjane", style: GoogleFonts.readexPro(fontSize: 15),),
                      Row(
                        children: [
                          Text("at ", style: GoogleFonts.readexPro(fontWeight: FontWeight.w300),),
                          SizedBox(
                            width: 180,
                            child: TextButton(onPressed: (){}, child: Text("Trường Đại học Khoa học Huế", style: GoogleFonts.readexPro(color: Colors.black), overflow: TextOverflow.ellipsis),
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  splashFactory: NoSplash.splashFactory,
                                )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_outlined),
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        //height: MediaQuery.of(context).size.height / 2.8,
                        aspectRatio: 1,
                        reverse: false,
                        scrollPhysics: BouncingScrollPhysics(),
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentPos = index;
                          });
                        }),
                    items: samplePost.photos.map((e) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25)),
                          child: Image.asset(e, width: double.infinity,)
                        );
                      });
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 1,
                    right: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: samplePost.photos.map((e) {
                        int index = samplePost.photos.indexOf(e);
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          width: currentPos == index ? 20 : 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                              shape: currentPos == index
                                  ? BoxShape.rectangle
                                  : BoxShape.rectangle,
                              borderRadius: currentPos == index
                                  ? BorderRadius.circular(8)
                                  : BorderRadius.circular(8),
                              color: currentPos == index
                                  ? Color.fromRGBO(255, 255, 255, 10)
                                  : Color.fromRGBO(236, 236, 236, 0.5)),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    //margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){

                        }, icon: Icon(Icons.favorite_outline_rounded, size: 30,),
                          splashColor: Colors.transparent,
                          highlightColor:  Colors.transparent,
                          hoverColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        )
                        
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }*/
}
