import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_t/providers/favorite_provider.dart';
import 'package:hue_t/view/accommodation_views/all_reviews.dart';
import 'package:hue_t/model/accommodation/accommodationModel.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hue_t/view/profileuser/favorite_page.dart';
import 'package:provider/provider.dart';
import '../../animation/show_right.dart';
import '../../colors.dart' as colors;
import '../../model/accommodation/reviewModel.dart';
import 'package:map_launcher/map_launcher.dart' as map;
import '../../permission/get_user_location.dart' as user_location;
import '../../constants/user_info.dart' as user_constants;

class HotelDetail extends StatefulWidget {
  const HotelDetail({Key? key, required this.model}) : super(key: key);
  final hotelModel model;

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  bool isloading = true;
  String address = "";
  int currentPos = 0;
  bool isFavorite = false;
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
        rating: 3,
        review: "Khách sạn có ma",
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
    var favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    user_constants.user == null
        ? isFavorite = false
        : isFavorite = favoriteProvider.checkFavorite(widget.model.id);
    user_location.getUserCurrentLocation().then((value) async {
      // marker added for hotels location
      final coordinates = Coordinates(
          widget.model.accommodationLocation.latitude,
          widget.model.accommodationLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      address = addresses.first.addressLine.toString();
      _markers.add(Marker(
          markerId: const MarkerId("3"),
          position: LatLng(widget.model.accommodationLocation.latitude,
              widget.model.accommodationLocation.longitude),
          infoWindow: const InfoWindow(title: "Hotel's Locations")));

      double miny =
          (value.latitude <= widget.model.accommodationLocation.latitude)
              ? value.latitude
              : widget.model.accommodationLocation.latitude;
      double minx =
          (value.longitude <= widget.model.accommodationLocation.longitude)
              ? value.longitude
              : widget.model.accommodationLocation.longitude;
      double maxy =
          (value.latitude <= widget.model.accommodationLocation.latitude)
              ? widget.model.accommodationLocation.latitude
              : value.latitude;
      double maxx =
          (value.longitude <= widget.model.accommodationLocation.longitude)
              ? widget.model.accommodationLocation.longitude
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
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: Center(
                                child: ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl: e ?? "",
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 2.8,
                                fit: BoxFit.cover,
                              ),
                            )),
                          );
                        });
                      }).toList(),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: widget.model.images.map((e) {
                      //       int index = widget.model.images.indexOf(e);
                      //       return AnimatedContainer(
                      //         duration: const Duration(milliseconds: 100),
                      //         width: currentPos == index ? 20 : 8.0,
                      //         height: 8.0,
                      //         margin: const EdgeInsets.symmetric(
                      //             vertical: 10.0, horizontal: 2.0),
                      //         decoration: BoxDecoration(
                      //             shape: currentPos == index
                      //                 ? BoxShape.rectangle
                      //                 : BoxShape.rectangle,
                      //             borderRadius: currentPos == index
                      //                 ? BorderRadius.circular(8)
                      //                 : BorderRadius.circular(8),
                      //             color: currentPos == index
                      //                 ? const Color.fromRGBO(255, 255, 255, 10)
                      //                 : const Color.fromRGBO(236, 236, 236, 0.5)),
                      //       );
                      //     }).toList(),
                      //   ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        height: 27,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black54.withOpacity(0.5)),
                        child: Center(
                            child: Text(
                          "${currentPos + 1}/${widget.model.images.length + 1}",
                          style: GoogleFonts.readexPro(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7)),
                        )),
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
                      style: GoogleFonts.readexPro(
                          color:
                              colors.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
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
                            text: address,
                            style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w400,
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18))
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
                              e['name'],
                              style: GoogleFonts.readexPro(
                                  color: colors.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w300),
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
                      style: GoogleFonts.readexPro(
                          fontSize: 20,
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
                                widget.model.accommodationLocation.latitude,
                                widget.model.accommodationLocation.longitude));
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
                            style: GoogleFonts.readexPro(
                                color: colors.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 21),
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
                                          const AllReviews(hotelId: 1)));
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent)),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "See all",
                                    style: GoogleFonts.readexPro(
                                        color: Colors.black, fontSize: 18)),
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
        Positioned(
          top: 40,
          left: 20,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Consumer<FavoriteProvider>(
                  builder: (context, value, child) => Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: IconButton(
                        onPressed: () {
                          if (!isFavorite) {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            value.addFavorite(
                                widget.model.id,
                                widget.model.name,
                                widget.model.address,
                                widget.model.image.toString(),
                                1,
                                user_constants.user!.uid);
                          } else {
                            setState(() {
                              isFavorite = !isFavorite;
                              value.deleteFavorite(
                                  widget.model.id, 1, user_constants.user!.uid);
                            });
                          }
                        },
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_sharp
                              : Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 27,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))))),
                  ),
                ),
              ],
            ),
          ),
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
                    text: "\$${widget.model.price}" " VND",
                    style: GoogleFonts.readexPro(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
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
