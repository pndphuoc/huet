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
  Completer<GoogleMapController> _controller = Completer();
  // on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )
    ),
  ];

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
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
                                  borderRadius: BorderRadius.circular(25),
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
                              return Container(
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
                    margin: EdgeInsets.only(top: 25),
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
                    margin: EdgeInsets.only(top: 15),
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
                                style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600,
                                    color: Colors.black, fontSize: 20))
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
                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w600,
                                    color: Colors.black, fontSize: 20))
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                ShowUp(
                  delay: 450,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 18,
                    runSpacing: 15,
                    children: [
                      ...widget.model.types.map((e) => Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width/4,
                        decoration: BoxDecoration(
                          color: colors.backgroundColor,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(child: Text(e.name, style: GoogleFonts.quicksand(color: Colors.black),)),
                      ))
                    ],
                  ),
                ),
                ShowUp(child: Container(
                  color: Colors.blue,
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    // on below line setting camera position
                    initialCameraPosition: _kGoogle,
                    // on below line we are setting markers on the map
                    markers: Set<Marker>.of(_marker),
                    // on below line specifying map type.
                    mapType: MapType.normal,
                    // on below line setting user location enabled.
                    myLocationEnabled: true,
                    // on below line setting compass enabled.
                    compassEnabled: true,
                    // on below line specifying controller on map complete.
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);
                    },
                  ),
                ), delay: 600)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
