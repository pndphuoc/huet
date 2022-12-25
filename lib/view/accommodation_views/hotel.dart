import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hue_t/animation/show_right.dart';
import 'package:hue_t/providers/accommodation_provider.dart';
import 'package:hue_t/view/accommodation_views/homestays_list.dart';
import 'package:hue_t/view/accommodation_views/hotels_list.dart';
import 'package:hue_t/view/accommodation_views/hotel_detail.dart';
import 'package:hue_t/view/accommodation_views/resorts_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../colors.dart' as colors;
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../fake_data.dart' as faker;
import '../../model/accommodation/accommodationModel.dart';
import '../../permission/get_user_location.dart' as userLocation;

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

  Future<void> distanceCaculating(Position value, List<hotelModel> list) async {
    for (int i = 0; i < list.length; i++) {
      list[i].distance = GeolocatorPlatform.instance.distanceBetween(
            value.latitude,
            value.longitude,
            list[i].accommodationLocation.latitude,
            list[i].accommodationLocation.longitude,
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

  // bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var accommodationProvider = Provider.of<AccomodationProvider>(context);

    if (accommodationProvider.isloading) {
      (() async {
        await accommodationProvider.getAll();
        accommodationProvider.listHotel =
            await accommodationProvider.filter("1", 5);
        accommodationProvider.listResort =
            await accommodationProvider.filter("2", 5);
        accommodationProvider.listHomestays =
            await accommodationProvider.filter("3", 5);
        await userLocation.getUserCurrentLocation().then((value) async {
          await distanceCaculating(value, accommodationProvider.list);
        });
        setState(() {
          accommodationProvider.isloading = false;
        });
      })();
    }

    if (isRecommendationHotel) {
      accommodationProvider.list.sort(
        (b, a) {
          return a.rating!.compareTo(b.rating!);
        },
      );
    } else {
      accommodationProvider.list.sort(
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
        body: accommodationProvider.isloading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: colors.primaryColor, size: 50),
              )
            : Stack(children: [
                SafeArea(
                    child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        searchBlock(context),
                        accommodationBlock(
                            context, "Hotels", accommodationProvider.listHotel),
                        accommodationBlock(context, "Resorts & Villas",
                            accommodationProvider.listResort),
                        accommodationBlock(context, "Homestays",
                            accommodationProvider.listHomestays),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "Popular accommodations",
                              style: GoogleFonts.readexPro(
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 25),
                            ),
                          ),
                        ),
                        sortBlock(context),
                        const SizedBox(
                          height: 15,
                        ),
                        ...accommodationProvider.list.map((e) =>
                            popularAccommondationItem(context,
                                accommodationProvider.list.indexOf(e))),
                        const SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                )),

/*                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: navigationBar.NavigationBar())*/
              ]),
      ),
    );
  }

  accommodationBlock(BuildContext context, String name, List<hotelModel> list) {
    return Container(
      decoration: BoxDecoration(
        color: colors.isDarkMode
            ? colors.backgroundColorDarkMode
            : colors.backgroundColor,
      ),
      margin: const EdgeInsets.only(
        top: 15,
      ),
      height: MediaQuery.of(context).size.height / 3.5,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              StatefulWidget direction;
              if (name == "Hotels") {
                direction = const HotelsPage(
                  idAccomodation: "1",
                  title: "Hot Hotels",
                  content: "Best-rated hotels in the last month",
                  image:
                      "https://cdn4.tropicalsky.co.uk/images/1800x600/indochine-palace-main-image.jpg",
                );
              } else if (name == "Resorts & Villas") {
                direction = const HotelsPage(
                  idAccomodation: "2",
                  title: "Resorts",
                  content: "Best-rated resort in the last month",
                  image:
                      "https://cdn4.tropicalsky.co.uk/images/1800x600/indochine-palace-main-image.jpg",
                );
              } else {
                direction = const HotelsPage(
                  idAccomodation: "3",
                  title: "Homestays",
                  content: "Best-rated homestays in the last month",
                  image:
                      "https://cdn4.tropicalsky.co.uk/images/1800x600/indochine-palace-main-image.jpg",
                );
              }
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => direction));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: colors.isDarkMode
                  ? colors.backgroundColorDarkMode
                  : colors.backgroundColor,
              margin: const EdgeInsets.only(left: 20, right: 20),
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.readexPro(
                            color:
                                colors.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    accommodationItemHorizonal(context, index, list),
              ),
            ),
          )
        ],
      ),
    );
  }

  accommodationItemHorizonal(BuildContext context, int index, list) {
    return BounceInUp(
      from: 60,
      delay: const Duration(milliseconds: 500),
      duration: Duration(milliseconds: 1500 + index * 300),
      child: Container(
        decoration: BoxDecoration(
            color: colors.isDarkMode
                ? colors.accomodationItemColorDarkMode
                : Colors.white,
            borderRadius: BorderRadius.circular(15)),
        margin: index == 0
            ? const EdgeInsets.only(left: 20)
            : index == list.length - 1
                ? const EdgeInsets.only(left: 10, right: 20)
                : const EdgeInsets.only(left: 10),
        child: GestureDetector(
            child: Container(
                width: MediaQuery.of(context).size.width / 2.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage(list[index].image),
                      fit: BoxFit.cover), // button text
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 7, bottom: 7),
                      child: Text(
                        list[index].name,
                        style: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ))),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => HotelDetail(model: list[index])));
            }),
      ),
    );
  }

  searchBlock(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.4)),
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
                Text(
                  "HUE ACCOMMODATION",
                  style: GoogleFonts.readexPro(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                  height: 45,
                )
              ],
            ),
          ),
          TextField(
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 240, 237, 237),
                hintText: "Search event ...",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 205, 205)),
                prefixIcon: Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                      width: 0.2, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(
                        width: 0.2,
                        color: Color.fromARGB(255, 255, 255, 255)))),
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
        margin: const EdgeInsets.only(
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
              duration: const Duration(milliseconds: 300),
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
                child: SizedBox(
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
                      )))
            ],
          ),
        ]),
      ),
    );
  }

  popularAccommondationItem(BuildContext context, int index) {
    return Consumer<AccomodationProvider>(builder: (context, value, child) {
      return BounceInLeft(
        delay: const Duration(milliseconds: 500),
        duration: Duration(milliseconds: 500 + index * 300),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // do something
                return HotelDetail(model: value.list[index]);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: value.list[index].image.toString(),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 20, right: 20, bottom: 20, left: 10),
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value.list[index].name,
                          style: GoogleFonts.readexPro(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
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
                                  full: const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  half: const Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  ),
                                  empty: const Icon(
                                    Icons.star_border,
                                    color: Colors.yellow,
                                  )),
                              onRatingUpdate: (rating) {},
                              itemSize: 15,
                              allowHalfRating: true,
                              initialRating: value.list[index].rating != null
                                  ? value.list[index].rating!
                                  : 0,
                            ),
                          ),
                          const TextSpan(text: " "),
                          TextSpan(
                              text: value.list[index].rating != null
                                  ? value.list[index].rating!.toString()
                                  : "No review",
                              style: GoogleFonts.readexPro(
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 11))
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          const WidgetSpan(
                              child: Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: Colors.grey,
                          )),
                          TextSpan(
                              text: value.list[index].distance != null
                                  ? " ${value.list[index].distance!.toStringAsFixed(2)} km"
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
                              text: "${value.list[index].price} VND",
                              style: GoogleFonts.readexPro(
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
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
      );
    });
  }
}
