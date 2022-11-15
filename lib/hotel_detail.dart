import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_t/all_reviews.dart';
import 'package:hue_t/fullscreen_map.dart';
import 'package:hue_t/model/hotelModel.dart';
import 'package:hue_t/show_up.dart';
import 'package:geolocator/geolocator.dart';
import 'colors.dart' as colors;
import 'model/reviewModel.dart';
import 'package:map_launcher/map_launcher.dart' as map;

class HotelDetail extends StatefulWidget {
  const HotelDetail({Key? key, required this.model}) : super(key: key);
  final hotelModel model;

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  int currentPos = 0;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Completer<GoogleMapController> _controller = Completer();

  // on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(16.462766512813303, 107.58981951625772),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[];

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  //reviews data
  List<reviewModel> reviewsList = [
    reviewModel(
        id: 1,
        rating: 5,
        review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        images: [
          "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
        ]),
    reviewModel(id: 2, rating: 4, review: "Normal"),
    reviewModel(id: 3, rating: 1, review: "Too bad")
  ];

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());

      // marker added for current users location
      // _markers.add(Marker(
      //   markerId: MarkerId("2"),
      //   position: LatLng(value.latitude, value.longitude),
      //   infoWindow: InfoWindow(
      //     title: 'Your Location',
      //   ),
      // ));

      // marker added for hotels location
      _markers.add(Marker(
          markerId: MarkerId("3"),
          position: LatLng(widget.model.hotelLocaton!.latitude,
              widget.model.hotelLocaton!.longitude),
          infoWindow: InfoWindow(title: "Hotel's Locations")));

      double miny = (value.latitude <= widget.model.hotelLocaton!.latitude)
          ? value.latitude
          : widget.model.hotelLocaton!.latitude;
      double minx = (value.longitude <= widget.model.hotelLocaton!.longitude)
          ? value.longitude
          : widget.model.hotelLocaton!.longitude;
      double maxy = (value.latitude <= widget.model.hotelLocaton!.latitude)
          ? widget.model.hotelLocaton!.latitude
          : value.latitude;
      double maxx = (value.longitude <= widget.model.hotelLocaton!.longitude)
          ? widget.model.hotelLocaton!.longitude
          : value.longitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // specified current users location
      CameraPosition cameraPosition = new CameraPosition(
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

      Timer(Duration(milliseconds: 500), () async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.hotelDetailBackgroundColor,
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ShowUp(
                    delay: 0,
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 2.8,
                              reverse: false,
                              scrollPhysics: BouncingScrollPhysics(),
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentPos = index;
                                });
                              }),
                          items: widget.model.images.map((e) {
                            return Builder(builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: ClipRRect(
                                  child: Image.network(
                                    e ?? "",
                                    height: MediaQuery.of(context).size.height /
                                        2.8,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),
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
                            children: widget.model.images.map((e) {
                              int index = widget.model.images.indexOf(e);
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
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(
                    delay: 150,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        widget.model.name,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(
                    delay: 300,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                  child: Icon(
                                Icons.pin_drop_outlined,
                                size: 20,
                                color: Colors.black,
                              )),
                              TextSpan(
                                  text: " ${widget.model.address}",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 20))
                            ]),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                  child: Icon(
                                Icons.star_rate_rounded,
                                size: 25,
                                color: colors.starsReviewColor,
                              )),
                              TextSpan(
                                  text: " ${widget.model.rating}/5",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 20))
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(
                    delay: 450,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 18,
                      runSpacing: 15,
                      children: [
                        ...widget.model.types.map((e) => Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                  color: colors.backgroundColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                  child: Text(
                                e.name,
                                style:
                                    GoogleFonts.quicksand(color: Colors.black),
                              )),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(
                      child: Text(
                        "Map",
                        style: GoogleFonts.montserrat(fontSize: 25),
                      ),
                      delay: 600),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(
                      child: GestureDetector(
                        onTap: () async {
                          final availableMaps = await map.MapLauncher.installedMaps;

                          await availableMaps.first.showDirections(destination: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude));

/*                          await availableMaps.first.showMarker(
                            coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                            title: widget.model.name,
                          );*/

                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          height: MediaQuery.of(context).size.width / 2,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
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
                                    child: Text("Click to open direction in Google Map", textAlign: TextAlign.center, style: GoogleFonts.montserrat(color: Colors.black),),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.7)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      delay: 600),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(
                    delay: 750,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reviews",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black, fontSize: 25),
                            ),
                            Row(
                              children: [
                                RatingBar(
                                  ratingWidget: RatingWidget(
                                      full: Icon(
                                        Icons.star,
                                        color: colors.starsReviewColor,
                                      ),
                                      half: Icon(
                                        Icons.star_half,
                                        color: colors.starsReviewColor,
                                      ),
                                      empty: Icon(
                                        Icons.star_border,
                                        color: colors.starsReviewColor,
                                      )),
                                  onRatingUpdate: (rating) {},
                                  itemSize: 15,
                                  allowHalfRating: true,
                                  initialRating: widget.model.rating!,
                                ),
                                Text(
                                  " ${widget.model.rating!}/5",
                                )
                              ],
                            )
                          ],
                        ),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllReviews(
                                            hotelId: widget.model.id)));
                              },
                              style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.transparent)),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "See all",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black, fontSize: 20)),
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.chevron_right_outlined,
                                    color: Colors.black,
                                  ))
                                ]),
                              )),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ...reviewsList.map((e) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ShowUp(child: reviewsBlock(context, e), delay: 900),
                  );
                })
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(top: 40, left: 20),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))))),
        ),
      ]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        color: colors.hotelDetailBackgroundColor,
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Price",
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "\$${widget.model.price}",
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                      text: "/night",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300))
                ]))
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: () {},
              child: Container(
                height: 50,
                child: Center(
                  child: Text("Book Now"),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.findButtonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  reviewsBlock(BuildContext context, reviewModel e) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors.reviewItemColor),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(right: 10),
                height: 30,
                width: 30,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/hotel/avatar.png"),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Incognito",
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  RatingBar(
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: colors.starsReviewColor,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: colors.starsReviewColor,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: colors.starsReviewColor,
                        )),
                    onRatingUpdate: (rating) {},
                    itemSize: 15,
                    allowHalfRating: true,
                    initialRating: e.rating.toDouble(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(e.review!),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      if (e.images != null)
                        ...e.images!.map((i) => Container(
                              width: 70,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      i,
                                      fit: BoxFit.fitHeight,
                                    )),
                              ),
                            ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
