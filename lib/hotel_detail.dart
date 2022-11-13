import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_t/model/hotelModel.dart';
import 'package:hue_t/show_up.dart';
import 'package:geolocator/geolocator.dart';
import 'colors.dart' as colors;

class HotelDetail extends StatefulWidget {
  const HotelDetail({Key? key, required this.model}) : super(key: key);
  final hotelModel model;

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  int currentPos = 0;

  @override
  // TODO: implement widget
  HotelDetail get widget => super.widget;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Completer<GoogleMapController> _controller = Completer();

  // on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
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

  Future<Position> getHotelLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 30),
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
                              height: MediaQuery.of(context).size.height / 3.3,
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
                                  borderRadius: BorderRadius.circular(25),
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
                ShowUp(
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
                ShowUp(
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
                              color: Color.fromARGB(255, 254, 200, 0),
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
                SizedBox(
                  height: 15,
                ),
                ShowUp(
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
                              style: GoogleFonts.quicksand(color: Colors.black),
                            )),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ShowUp(
                    child: Text(
                      "Map",
                      style: GoogleFonts.montserrat(fontSize: 25),
                    ),
                    delay: 600),
                ShowUp(
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
                        child: GoogleMap(
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
                      ),
                    ),
                    delay: 600)
              ],
            ),
          ),
        ),
      ),
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
}
