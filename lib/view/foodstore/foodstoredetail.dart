import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:hue_t/model/foodstore/restaurant.dart';
import 'package:hue_t/model/accommodation/reviewModel.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:map_launcher/map_launcher.dart' as mapp;

import 'dart:async';
import '../../permission/get_user_location.dart' as user_location;

class FoodstoreDetail extends StatefulWidget {
  final Restaurant item;

  const FoodstoreDetail({Key? key, required this.item}) : super(key: key);

  @override
  State<FoodstoreDetail> createState() => _FoodstoreDetailState();
}

class _FoodstoreDetailState extends State<FoodstoreDetail> {
  var link = 1;
  DateTime now = DateTime.now();

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Completer<GoogleMapController> _controller = Completer();

  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(16.462766512813303, 107.58981951625772),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[];

  @override
  void initState() {
    super.initState();

    user_location.getUserCurrentLocation().then((value) async {
      // marker added for hotels location

      _markers.add(Marker(
          markerId: const MarkerId("3"),
          position: LatLng(widget.item!.latitude, widget.item!.longitude),
          infoWindow: const InfoWindow(title: "Hotel's Locations")));

      double miny = (value.latitude <= widget.item!.latitude)
          ? value.latitude
          : widget.item!.latitude;
      double minx = (value.longitude <= widget.item!.longitude)
          ? value.longitude
          : widget.item!.longitude;
      double maxy = (value.latitude <= widget.item!.latitude)
          ? widget.item!.latitude
          : value.latitude;
      double maxx = (value.longitude <= widget.item!.longitude)
          ? widget.item!.longitude
          : value.longitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;
      setState(() {});
      // specified current users location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;

      @override
      void dispose() {
        controller.dispose();
        // ignore: avoid_print
        super.dispose();
      }

      Timer(const Duration(milliseconds: 1000), () async {
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(
              LatLngBounds(
                northeast: LatLng(northEastLatitude, northEastLongitude),
                southwest: LatLng(southWestLatitude, southWestLongitude),
              ),
              30),
        );
      });
      setState(() {});
    });
  }

  List<reviewModel> reviewsList1 = [
    reviewModel(
        id: 1,
        userId: 1,
        rating: 5,
        review: "Quán đồ ăn dở như mặt Duy Phước",
        images: [
          "assets/images/foodstore/restaurant/1.jpg",
          "assets/images/foodstore/restaurant/2.jpg",
          "assets/images/foodstore/restaurant/3.jpg"
        ],
        reviewDate: DateTime(2022, 11, 15, 12, 56)),
    reviewModel(
        id: 2,
        userId: 1,
        rating: 4,
        review: "Em yêu Anh Quang nhiều lắm hihi, đã đẹp trai, còn học giỏi",
        images: ["assets/images/foodstore/restaurant/4.jpg"],
        reviewDate: DateTime(2022, 11, 15, 12, 56)),
    reviewModel(
        id: 3,
        userId: 1,
        rating: 1,
        review: "Phước xấu trai như quán",
        images: [
          "assets/images/foodstore/restaurant/5.jpg",
          "assets/images/foodstore/restaurant/6.jpg",
        ],
        reviewDate: DateTime(2022, 11, 15, 12, 56))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: color.backgroundColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [header(context), body(context)],
          ),
        ),
      ),
    );
  }

  header(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.item.image.toString(),
            width: double.infinity,
            height: 230,
            fit: BoxFit.cover,
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: 20,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 215, 215)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40)),
                        child: const Center(
                            child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 17,
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 215, 215)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40)),
                        child: const Center(
                            child: Icon(
                          Icons.favorite_border_outlined,
                          size: 20,
                        )),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 200),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color.backgroundColor),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.title.toString(),
                    style: GoogleFonts.readexPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 104, 104, 172))),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Text(widget.item.address.toString(),
                              maxLines: 2,
                              style: GoogleFonts.readexPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(
                                      255, 109, 109, 109))),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          final availableMaps =
                              await mapp.MapLauncher.installedMaps;

                          await availableMaps.first.showDirections(
                              destination: mapp.Coords(
                                  widget.item.latitude, widget.item.longitude));

                          /*                          await availableMaps.first.showMarker(
                            coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                            title: widget.model.name,
                          );*/
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                      offset: const Offset(2, 3),
                                      color: Colors.grey.withOpacity(0.6))
                                ]),
                            child: Transform.rotate(
                              angle: 45,
                              child: const Icon(
                                Icons.navigation_outlined,
                                color: Color.fromARGB(255, 104, 104, 172),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text((widget.item.rating! - 5).toStringAsFixed(1),
                        style: GoogleFonts.readexPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 109, 109, 109))),
                    const SizedBox(
                      width: 7,
                    ),
                    Text("-  ${widget.item.checkin} Checkin",
                        style: GoogleFonts.readexPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 109, 109, 109))),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("${widget.item.open}:00 - ${widget.item.close}:00",
                        style: GoogleFonts.readexPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 96, 97, 96))),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money_outlined,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        "${widget.item.mincost}.000 - ${widget.item.maxcost}.000 VND",
                        style: GoogleFonts.readexPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 96, 97, 96)))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 0.2,
                            color: Color.fromARGB(181, 117, 117, 172)))),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          link = 1;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: const BoxDecoration(),
                        child: Center(
                          child: Text("Reviews",
                              style: GoogleFonts.readexPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: link == 1
                                      ? const Color.fromARGB(255, 104, 104, 172)
                                      : const Color.fromARGB(255, 84, 84, 85))),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          link = 2;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: const BoxDecoration(),
                        child: Center(
                          child: Text("Images",
                              style: GoogleFonts.readexPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: link == 2
                                      ? const Color.fromARGB(255, 104, 104, 172)
                                      : const Color.fromARGB(255, 84, 84, 85))),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          link = 3;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: const BoxDecoration(),
                        child: Center(
                          child: Text("Map",
                              style: GoogleFonts.readexPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: link == 3
                                      ? const Color.fromARGB(255, 104, 104, 172)
                                      : const Color.fromARGB(255, 84, 84, 85))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AnimatedPositioned(
                  bottom: 0,
                  left: link == 1
                      ? 0
                      : link == 2
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width * 2 / 3,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 104, 104, 172)))),
                  ))
            ],
          ),
          link == 1
              ? introduce(context)
              : link == 2
                  ? menu(context)
                  : map(context)
        ],
      ),
    );
  }

  introduce(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Text(
        //     widget.item.description.toString(),
        //     style: GoogleFonts.readexPro(
        //         fontSize: 15,
        //         fontWeight: FontWeight.w400,
        //         color: Color.fromARGB(255, 109, 109, 109)),
        //     textAlign: TextAlign.justify,
        //   ),
        // ),
        const SizedBox(
          height: 20,
        ),
        review(context),
      ],
    );
  }

  menu(BuildContext context) {
    if (widget.item.menu!.length < 2) {
      return Text(
        "No Image !",
        style: GoogleFonts.readexPro(fontSize: 15),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisExtent: 100,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2),
            itemCount: widget.item.menu!.length,
            itemBuilder: (BuildContext ctx, index) {
              return CachedNetworkImage(
                imageUrl: widget.item.menu![index]['ImageUrl'],
                fit: BoxFit.cover,
              );
            }),
      );
    }
  }

  map(BuildContext context) {
    return ShowUp(
      delay: 600,
      child: GestureDetector(
        onTap: () async {
          final availableMaps = await mapp.MapLauncher.installedMaps;

          await availableMaps.first.showDirections(
              destination:
                  mapp.Coords(widget.item.latitude, widget.item.longitude));

          /*                          await availableMaps.first.showMarker(
                            coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                            title: widget.model.name,
                          );*/
        },
        child: Container(
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  // on below line setting camera position
                  initialCameraPosition: _kGoogle,
                  // on below line we are setting markers on the map
                  markers: Set<Marker>.of(_markers),
                  // on below line specifying map type.
                  mapType: MapType.terrain,
                  // on below line setting user location enabled.
                  myLocationEnabled: true,
                  // on below line setting compass enabled.
                  //compassEnabled: true,
                  // on below line specifying controller on map complete.
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.7)),
                    child: Text(
                      "Click to open direction in Google Map",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color:
                              color.isDarkMode ? Colors.white : Colors.black),
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

  review(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   width: double.infinity,
        //   height: 35,
        //   decoration: BoxDecoration(),
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20.0, right: 20),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text("",
        //             style: GoogleFonts.readexPro(
        //                 fontSize: 19,
        //                 fontWeight: FontWeight.w600,
        //                 color: Color.fromARGB(255, 63, 63, 63))),
        //         Text("See All",
        //             style: GoogleFonts.readexPro(
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.w600,
        //                 color: Color.fromARGB(255, 104, 104, 172)))
        //       ],
        //     ),
        //   ),
        // ),
        SingleChildScrollView(
          child: Column(
            children: [
              ...widget.item.description!.map((e) => Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.item.category![0] == '2'
                                        ? e['OwnerAvatar']
                                        : widget.item.category![0] == '4'
                                            ? e['OwnerAvatar']
                                            : widget.item.category![0] == '3'
                                                ? e['OwnerAvatar']
                                                : e['reviewUserAvatar'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 105,
                                  height: 42,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.item.category![0] == '2'
                                              ? e['OwnerUserName']
                                              : widget.item.category![0] == '4'
                                                  ? e['OwnerUserName']
                                                  : widget.item.category![0] ==
                                                          '3'
                                                      ? e['OwnerUserName']
                                                      : e[
                                                          'reviewUserDisplayName'],
                                          style: GoogleFonts.readexPro(
                                              color: const Color.fromARGB(
                                                  255, 71, 71, 71),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RatingBar(
                                            ratingWidget: RatingWidget(
                                                full: Icon(
                                                  Icons.star,
                                                  color: color.starsReviewColor,
                                                ),
                                                half: Icon(
                                                  Icons.star_half,
                                                  color: color.starsReviewColor,
                                                ),
                                                empty: Icon(
                                                  Icons.star_border,
                                                  color: color.starsReviewColor,
                                                )),
                                            onRatingUpdate: (rating) {},
                                            itemSize: 15,
                                            allowHalfRating: true,
                                            initialRating: (e['AvgRating']! - 5)
                                                .toDouble(),
                                          ),
                                          Text(
                                            "${now.difference(DateTime(2022, 11, 15, 12, 56)).inDays} ngày trước",
                                            style: GoogleFonts.readexPro(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 131, 130, 130)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(e['Comment'],
                            style: GoogleFonts.readexPro(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color:
                                    const Color.fromARGB(255, 102, 102, 102))),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ...reviewsList1[0].images!.map((e) => Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  width: 60,
                                  height: 60,
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          e,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
