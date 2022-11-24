import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hue_t/animation/show_right.dart';
import 'package:hue_t/accommodation_views/homestays_list.dart';
import 'package:hue_t/accommodation_views/hotels_list.dart';
import 'package:hue_t/accommodation_views/hotel_detail.dart';
import 'package:hue_t/accommodation_views/resorts_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../colors.dart' as colors;
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../fake_data.dart' as faker;
import '../get_user_location.dart' as userLocation;

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

final ScrollController scrollController = ScrollController();
bool isRecommendationHotel = true;
bool _innerBoxIsScrolled = false;

class _HotelPageState extends State<HotelPage> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  String selectedCheckInDate = '';
  String selectedCheckOutDate = '';
  late final TabController _tabController;

  Future<void> distanceCaculating(Position value) async {
    for (int i = 0; i < faker.listHotels.length; i++) {
      faker.listHotels[i].distance =
          GeolocatorPlatform.instance.distanceBetween(
                value.latitude,
                value.longitude,
                faker.listHotels[i].accommodationLocation.latitude,
                faker.listHotels[i].accommodationLocation.longitude,
              ) /
              1000;
    }
  }

  @override
  void initState() {
    super.initState();
/*    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());
    });*/
    _tabController = TabController(length: 3, vsync: this);
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      userLocation.getUserCurrentLocation().then((value) async {
        await distanceCaculating(value);
        setState(() {
          isLoading = false;
        });
      });
    }

    if (isRecommendationHotel) {
      faker.listHotels.sort(
        (b, a) {
          return a.rating!.compareTo(b.rating!);
        },
      );
    } else {
      faker.listHotels.sort(
        (a, b) {
          return a.distance!.compareTo(b.distance!);
        },
      );
    }
    var top = 0.0;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: colors.isDarkMode
            ? colors.backgroundColorDarkMode
            : colors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: colors.primaryColor, size: 50),
              )
            : Stack(children: [
                SafeArea(
                  child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            flexibleSpace: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                top = constraints.biggest.height;
                                return ShowUp(
                                  delay: 0,
                                  child: FlexibleSpaceBar(
                                    centerTitle: true,
                                    title: Container(
                                      child: Text(
                                        "Find the perfect\naccommodations",
                                        style: GoogleFonts.montserrat(
                                            color: innerBoxIsScrolled
                                                ? colors.backgroundColorDarkMode
                                                : colors.backgroundColor,
                                            fontSize: 25),
                                      ),
                                      margin: EdgeInsets.only(bottom: 70),
                                    ),
                                    background: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/hotel/img.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                );
                              },
                            ),
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            expandedHeight:
                                MediaQuery.of(context).size.height / 3,
                            floating: false,
                            pinned: true,
                            backgroundColor: colors.isDarkMode
                                ? colors.backgroundColorDarkMode
                                : colors.backgroundColor,
                            bottom: PreferredSize(
                                child: ShowUp(
                                  delay: 200,
                                  child:
                                      searchBlock(context, innerBoxIsScrolled),
                                ),
                                preferredSize: Size.fromHeight(34)),
                          )
                        ];
                      },
                      body: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              accommodationBlock(context, "Hotels"),
                              accommodationBlock(context, "Resorts/Villas"),
                              accommodationBlock(context, "Homestays"),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Popular accommodations",
                                  style: GoogleFonts.poppins(
                                      color: colors.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 25),
                                ),
                              ),
                              sortBlock(context),
                              SizedBox(
                                height: 15,
                              ),
                              ...faker.listHotels.map((e) =>
                                  popularAccommondationItem(
                                      context, faker.listHotels.indexOf(e))),
                              SizedBox(
                                height: 60,
                              )
                            ],
                          ),
                        ),
                      )),
                ),
/*                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: navigationBar.NavigationBar())*/
              ]),
      ),
    );
  }

  accommodationBlock(BuildContext context, String name) {
    return Container(
      decoration: BoxDecoration(
        color: colors.isDarkMode
            ? colors.backgroundColorDarkMode
            : colors.backgroundColor,
      ),
      margin: EdgeInsets.only(
        top: 15,
      ),
      height: MediaQuery.of(context).size.height / 3.5,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              StatefulWidget direction;
              if (name == "Hotels")
                direction = HotelsPage();
              else if (name == "Resorts/Villas")
                direction = ResortsPage();
              else
                direction = HomestaysPage();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => direction));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: colors.isDarkMode
                  ? colors.backgroundColorDarkMode
                  : colors.backgroundColor,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ShowRight(
                delay: 300,
                /*child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Hot Hotels", style: GoogleFonts.poppins(color: Colors.black, fontSize: 25)),
                      WidgetSpan(child: Icon(Icons.keyboard_arrow_right))
                    ]
                  ),
                )*/
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 25),
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: faker.listHotels.length,
                itemBuilder: (context, index) =>
                    accommodationItemHorizonal(context, index),
              ),
            ),
          )
        ],
      ),
    );
  }

  accommodationItemHorizonal(BuildContext context, int index) {
    return ShowUp(
      delay: 400 + index * 100,
      child: Container(
        decoration: BoxDecoration(
            color: colors.isDarkMode
                ? colors.accomodationItemColorDarkMode
                : Colors.white,
            borderRadius: BorderRadius.circular(15)),
        margin: index == 0
            ? EdgeInsets.only(left: 20)
            : index == faker.listHotels.length - 1
                ? EdgeInsets.only(left: 10, right: 20)
                : EdgeInsets.only(left: 10),
        child: GestureDetector(
            child: Container(
                width: MediaQuery.of(context).size.width / 2.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage(faker.listHotels[index].images.first),
                      fit: BoxFit.cover), // button text
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 7, bottom: 7),
                      child: Text(
                        faker.listHotels[index].name,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                    ))),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // do something
                return HotelDetail(model: faker.listHotels[index]);
              }));
            }),
      ),
    );
  }

  banner(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Text(
        "Find the perfect \naccommodations",
        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 25),
      ),
    );
  }

  searchBlock(BuildContext context, bool innerBoxIsScrolled) {
    print("testt ${innerBoxIsScrolled}");
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          //color: innerBoxIsScrolled?colors.backgroundColor:Colors.transparent
          ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
              child: SizedBox(
                height: 60,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Accommodation's name",
                      hintStyle: GoogleFonts.montserrat(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black),
                      border: OutlineInputBorder(
                          //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), topLeft: Radius.circular(15)),
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colors.isDarkMode
                          ? colors.accomodationItemColorDarkMode
                          : colors.accommodationItemColor),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15, bottom: 15, top: 15, left: 15),
            height: 60,
            width: 60,
            child: ElevatedButton(
              onPressed: () {},
              child: Center(
                child: Icon(Icons.search),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryColor,
                  shape: RoundedRectangleBorder(
                    //borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
          )
        ],
      ),
    );
  }

  sortBlock(BuildContext context) {
    return ShowRight(
      delay: 300,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: colors.isDarkMode
                ? colors.accomodationItemColorDarkMode
                : colors.accommodationItemColor,
            borderRadius: BorderRadius.circular(25)),
        child: Stack(children: [
          /*AnimatedContainer(duration: Duration(milliseconds: 500),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(25)
            ),
            width: double.infinity/2,
            height: double.infinity,

            child: Container(),
          ),*/
          LayoutBuilder(builder: (ctx, constraints) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(
                  left: isRecommendationHotel ? 5 : constraints.maxWidth * 0.5,
                  top: 5,
                  bottom: 5,
                  right: 5),
              height: constraints.maxHeight,
              width: constraints.maxWidth * 0.5,
              child: Container(
                decoration: BoxDecoration(
                    color: colors.isDarkMode
                        ? colors.backgroundColorDarkMode
                        : colors.backgroundColor,
                    borderRadius: BorderRadius.circular(25)),
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent)),
                        onPressed: () {
                          setState(() {
                            isRecommendationHotel = true;
                          });
                        },
                        child: Text(
                          "Recommendation",
                          style: isRecommendationHotel == true
                              ? GoogleFonts.montserrat(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.w600)
                              : GoogleFonts.montserrat(color: Colors.black),
                        ))),
              ),
              Expanded(
                  child: Container(
                      child: TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              isRecommendationHotel = false;
                            });
                          },
                          child: Text(
                            "Near to you",
                            style: isRecommendationHotel == false
                                ? GoogleFonts.montserrat(
                                    color: colors.primaryColor,
                                    fontWeight: FontWeight.w600)
                                : GoogleFonts.montserrat(color: Colors.black),
                          ))))
            ],
          ),
        ]),
      ),
    );
  }

  popularAccommondationItem(BuildContext context, int index) {
    return ShowRight(
      delay: 400 + index * 100,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              // do something
              return HotelDetail(model: faker.listHotels[index]);
            }));
          },
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shadowColor: Colors.white,
              backgroundColor: colors.isDarkMode
                  ? colors.accomodationItemColorDarkMode
                  : colors.accommodationItemColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      faker.listHotels[index].images.first,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 20, right: 20, bottom: 20, left: 10),
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          faker.listHotels[index].name,
                          style: GoogleFonts.notoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          maxLines: 1,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                            child: RatingBar(
                              ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  ),
                                  empty: Icon(
                                    Icons.star_border,
                                    color: Colors.yellow,
                                  )),
                              onRatingUpdate: (rating) {},
                              itemSize: 15,
                              allowHalfRating: true,
                              initialRating:
                                  faker.listHotels[index].rating != null
                                      ? faker.listHotels[index].rating!
                                      : 0,
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(
                              text: faker.listHotels[index].rating != null
                                  ? faker.listHotels[index].rating!.toString()
                                  : "No review",
                              style: GoogleFonts.montserrat(
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 11))
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: Colors.grey,
                          )),
                          TextSpan(
                              text: faker.listHotels[index].distance != null
                                  ? " ${faker.listHotels[index].distance!.toStringAsFixed(2)} km"
                                  : " km",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black))
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.attach_money,
                            size: 20,
                            color:
                                colors.isDarkMode ? Colors.white : Colors.black,
                          )),
                          TextSpan(
                              text: faker.listHotels[index].price.toString(),
                              style: GoogleFonts.montserrat(
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: "/night",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12, color: Colors.grey))
                        ]))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
