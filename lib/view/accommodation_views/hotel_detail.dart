import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_t/view/accommodation_views/all_reviews.dart';
import 'package:hue_t/model/accommodation/accommodationModel.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:geolocator/geolocator.dart';
import '../../animation/show_right.dart';
import '../../colors.dart' as colors;
import '../../model/accommodation/reviewModel.dart';
import 'package:map_launcher/map_launcher.dart' as map;
import '../../permission/get_user_location.dart' as userLocation;

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

  final Completer<GoogleMapController> _controller = Completer();

  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(16.462766512813303, 107.58981951625772),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[];

  //reviews data
  List<reviewModel> reviewsList = [
    reviewModel(
        id: 1,
        userId: 1,
        rating: 5,
        review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        images: [
          "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
        ],
        reviewDate: DateTime(2022, 11, 15, 12, 56)),
    reviewModel(
        id: 2,
        userId: 1,
        rating: 4,
        review: "Normal",
        reviewDate: DateTime(2022, 11, 15, 12, 56)),
    reviewModel(
        id: 3,
        userId: 1,
        rating: 1,
        review: "Too bad",
        reviewDate: DateTime(2022, 11, 15, 12, 56))
  ];

  @override
  void initState() {
    super.initState();
    userLocation.getUserCurrentLocation().then((value) async {
      // marker added for hotels location
      _markers.add(Marker(
          markerId: const MarkerId("3"),
          position: LatLng(widget.model.accommodationLocation!.latitude,
              widget.model.accommodationLocation!.longitude),
          infoWindow: const InfoWindow(title: "Hotel's Locations")));

      double miny =
          (value.latitude <= widget.model.accommodationLocation!.latitude)
              ? value.latitude
              : widget.model.accommodationLocation!.latitude;
      double minx =
          (value.longitude <= widget.model.accommodationLocation!.longitude)
              ? value.longitude
              : widget.model.accommodationLocation!.longitude;
      double maxy =
          (value.latitude <= widget.model.accommodationLocation!.latitude)
              ? widget.model.accommodationLocation!.latitude
              : value.latitude;
      double maxx =
          (value.longitude <= widget.model.accommodationLocation!.longitude)
              ? widget.model.accommodationLocation!.longitude
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.isDarkMode
          ? colors.backgroundColorDarkMode
          : colors.hotelDetailBackgroundColor,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowUp(
                delay: 0,
                child: Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height / 2.8,
                          reverse: false,
                          scrollPhysics: const BouncingScrollPhysics(),
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
                                height:
                                    MediaQuery.of(context).size.height / 2.8,
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
                            duration: const Duration(milliseconds: 100),
                            width: currentPos == index ? 20 : 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: currentPos == index
                                    ? BoxShape.rectangle
                                    : BoxShape.rectangle,
                                borderRadius: currentPos == index
                                    ? BorderRadius.circular(8)
                                    : BorderRadius.circular(8),
                                color: currentPos == index
                                    ? const Color.fromRGBO(255, 255, 255, 10)
                                    : const Color.fromRGBO(236, 236, 236, 0.5)),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: ShowUp(
                  delay: 150,
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      widget.model.name,
                      style: GoogleFonts.quicksand(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: ShowUp(
                  delay: 300,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.pin_drop_outlined,
                          size: 20,
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                        )),
                        TextSpan(
                            text: " ${widget.model.address}",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20))
                      ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
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
                                color: colors.isDarkMode
                                    ? colors.categoryBlockColorDarkMode
                                    : colors.categoryBlockColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Text(
                              e.name,
                              style: GoogleFonts.quicksand(
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            )),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: ShowRight(
                    delay: 600,
                    child: Text(
                      "Map",
                      style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black),
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: ShowUp(
                    delay: 600,
                    child: GestureDetector(
                      onTap: () async {
                        final availableMaps =
                            await map.MapLauncher.installedMaps;

                        await availableMaps.first.showDirections(
                            destination: map.Coords(
                                widget.model.accommodationLocation!.latitude,
                                widget.model.accommodationLocation!.longitude));

/*                          await availableMaps.first.showMarker(
                          coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                          title: widget.model.name,
                        );*/
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: MediaQuery.of(context).size.width / 2,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
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
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.7)),
                                  child: Text(
                                    "Click to open direction in Google Map",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: colors.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: ShowRight(
                  delay: 750,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reviews",
                            style: GoogleFonts.montserrat(
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 25),
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
                                style: GoogleFonts.poppins(
                                    color: colors.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
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
                                      builder: (context) =>
                                          AllReviews(hotelId: 1)));
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
                                const WidgetSpan(
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
              const SizedBox(
                height: 15,
              ),
              ...reviewsList.map((e) {
                return Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: ShowUp(child: reviewsBlock(context, e), delay: 900),
                );
              })
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.only(top: 40, left: 20),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))))),
        ),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
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
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: const SizedBox(
                height: 50,
                child: Center(
                  child: Text("Book Now"),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  reviewsBlock(BuildContext context, reviewModel e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors.reviewItemColor),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                height: 30,
                width: 30,
                child: const CircleAvatar(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    e.review!,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      if (e.images != null)
                        ...e.images!.map((i) => SizedBox(
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
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    e.reviewDate.toString(),
                    style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 13),
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