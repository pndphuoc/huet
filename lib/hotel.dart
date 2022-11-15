import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hue_t/hotel_detail.dart';
import 'package:hue_t/model/locationModel.dart';
import 'package:hue_t/model/roomTypeModel.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'colors.dart' as colors;
import 'model/hotelModel.dart';
import 'fade_on_scroll.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/show_up.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}

List<roomTypeModel> roomTypesOfHuongGiangHotel = [
  roomTypeModel(id: 1, name: "Single room"),
  roomTypeModel(id: 2, name: "Double room"),
  roomTypeModel(id: 3, name: "Triple room"),
  roomTypeModel(id: 4, name: "VIP room")
];
List<String> imagesOfHuongGiangHotel = [
  'https://www.huonggianghotel.com.vn/wp-content/uploads/2018/08/DSC_1308-HDR-Custom-1.jpg',
  'https://www.huonggianghotel.com.vn/wp-content/uploads/2018/06/DSC_4563-HDR2_1600x1068-1.jpg',
  'https://cf.bstatic.com/xdata/images/hotel/max1280x900/185016305.jpg?k=e0510db64b6c0f4b0623cb63a4014b95c677970d880c414c864fbbe094a9211c&o=&hp=1'
];
List<hotelModel> listHotels = [
  hotelModel(
      id: 1,
      name: "Silk Path Grand Hue Hotel",
      address: "2 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.458015573692116, longitude: 107.57969752805363),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 5),
  hotelModel(
      id: 1,
      name: "Hương Giang",
      address: "69 Lê Lợi",
      hotelLocaton:
          location(latitude: 16.470970686019427, longitude: 107.5944807077246),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4),
  hotelModel(
      id: 2,
      name: "Vinpearl Hue",
      address: "50A Hùng Vương",
      hotelLocaton:
          location(latitude: 16.463430881885497, longitude: 107.59451227529739),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 3,
      name: "The Manor Crown Huế",
      address: "62 Tố Hữu",
      hotelLocaton:
          location(latitude: 16.463786394219735, longitude: 107.60703420242594),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 3.5),
  hotelModel(
      id: 1,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      hotelLocaton:
          location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
];

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

final ScrollController scrollController = ScrollController();
bool isRecommendationHotel = true;

class _HotelPageState extends State<HotelPage> {
  final ScrollController scrollController = ScrollController();
  String selectedCheckInDate = '';
  String selectedCheckOutDate = '';

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> distanceCaculating(Position value) async {
    for (int i = 0; i < listHotels.length; i++) {
      listHotels[i].distance = GeolocatorPlatform.instance.distanceBetween(
            value.latitude,
            value.longitude,
            listHotels[i].hotelLocaton.latitude,
            listHotels[i].hotelLocaton.longitude,
          ) /
          1000;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());
    });
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getUserCurrentLocation().then((value) async {
        print(value.latitude.toString() + " " + value.longitude.toString());
        await distanceCaculating(value);
        setState(() {
          isLoading = false;
        });
      });
    }

    if (isRecommendationHotel)
    {
      listHotels.sort((b, a) {
        return a.rating!.compareTo(b.rating!);
      },);
    }
    else
    {
      listHotels.sort((a, b) {
        return a.distance!.compareTo(b.distance!);
      },);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: colors.primaryColor, size: 50),
                )
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: banner(context),
                          background: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/hotel/img.png"))),
                          ),
                        ),
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        expandedHeight:
                            MediaQuery.of(context).size.height / 3.33,
                        floating: false,
                        backgroundColor: Colors.transparent,
                      )
                    ];
                  },
                  body: Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        child: searchBlock(context),
                      ),
                      sortBlock(context),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: AnimationLimiter(
                          child: ShowUp(
                            delay: 450,
                            child: ImplicitlyAnimatedList<hotelModel>(
                              items: listHotels,
                              itemBuilder: (context, animation, item, index) => SizeFadeTransition(
                                  animation: animation,
                                  sizeFraction: 0.7,
                                key: Key(item.id.toString()),
                                child: hotelItem(context, item),
                              ),
                              areItemsTheSame: (a, b) => a.id == b.id,
                            ),
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

  banner(BuildContext context) {
    return ShowUp(
      delay: 0,
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: Text(
          "Find the perfect \nhotel",
          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 25),
        ),
        /* child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "Find the",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.white, fontSize: 25))),
              TextSpan(
                  text: "perfect",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: colors.primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))),
              TextSpan(
                  text: " hotel ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.white, fontSize: 25))),
              TextSpan(
                  text: "for your ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.white, fontSize: 25))),
              TextSpan(
                  text: "TRIP ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: colors.primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))),
              WidgetSpan(
                  child: Icon(
                Icons.directions_bike_outlined,
                size: 20,
                color: Colors.white,
              ))
            ])),*/
/*        child: Stack(
          children: [
            Image.asset("assets/images/hotel/img.png"),
            Container(
              margin: EdgeInsets.all(15),
              child: Positioned(
                child: Text("Find the perfect hotel", style: GoogleFonts.montserrat(fontSize: 25),),
                bottom: 30,
              ),
            )
          ],
        ),*/
      ),
    );
  }

  searchBlock(BuildContext context) {
    return ShowUp(
      delay: 150,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Name of hotel/homestay',
                    hintStyle: GoogleFonts.montserrat(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: colors.filterItemColor),
              ),
            ),
            /*Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: ElevatedButton(
                          onPressed: () => _selectCheckInDate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.filterItemColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            selectedCheckInDate != ''
                                ? selectedCheckInDate
                                : "Check-In",
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 60,
                    margin: EdgeInsets.only(right: 15, top: 15),
                    child: ElevatedButton(
                        onPressed: () => _selectCheckOutDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.filterItemColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          selectedCheckOutDate != ''
                              ? selectedCheckOutDate
                              : "Check-Out",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ))
                ],
              ),
            ),*/
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                child: Center(
                  child: Text(
                    "Find",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: colors.findButtonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            )
          ],
        ),
      ),
    );
  }

  sortBlock(BuildContext context) {
    return ShowUp(
      delay: 300,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: colors.hotelListViewItem,
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
                    color: colors.filterItemColor,
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)
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
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)
                                : GoogleFonts.montserrat(color: Colors.black),
                          ))))
            ],
          ),
        ]),
      ),
    );
  }

  _selectCheckInDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    setState(() {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectedCheckInDate = formatter.format(selectedDate);
    });
  }

  _selectCheckOutDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    setState(() {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectedCheckOutDate = formatter.format(selectedDate);
    });
  }

  hotelItem(BuildContext context, hotelModel model) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            // do something
            return HotelDetail(model: model);
          }));
        },
        style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
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
                    model.images.first,
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
                        model.name,
                        style: GoogleFonts.notoSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                                model.rating != null ? model.rating! : 0,
                          ),
                        ),
                        TextSpan(text: " "),
                        TextSpan(
                            text: model.rating != null
                                ? model.rating!.toString()
                                : "No review",
                            style: GoogleFonts.montserrat(
                                color: Colors.black, fontSize: 11))
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
                            text: model.distance != null
                                ? " ${model.distance!.toStringAsFixed(2)} km"
                                : " km",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black))
                      ])),
                      RichText(
                          text: TextSpan(children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.attach_money,
                          size: 20,
                          color: Colors.black,
                        )),
                        TextSpan(
                            text: model.price.toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
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
    );
  }
}
