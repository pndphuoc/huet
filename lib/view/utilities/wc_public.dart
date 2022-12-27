import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:map_launcher/map_launcher.dart' as mapp;
import '../../permission/get_user_location.dart' as userLocation;

import '../../animation/show_up.dart';

class WCPublicPage extends StatefulWidget {
  const WCPublicPage({super.key});

  @override
  State<WCPublicPage> createState() => _WCPublicPageState();
}

class _WCPublicPageState extends State<WCPublicPage> {
  int value = 1;
  @override
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

    userLocation.getUserCurrentLocation().then((value) async {
      // marker added for hotels location

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

      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categories(context),
                    map(context),
                    listLocation(context)
                  ],
                ),
              ),
            ),
            Positioned(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.1)),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                    ),
                    Text(
                      "WC Public Location",
                      style: GoogleFonts.readexPro(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 40,
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  categories(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  value = 1;
                  FocusScope.of(context).requestFocus(FocusNode());

                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: value == 1
                          ? const Color.fromARGB(255, 104, 104, 172)
                          : const Color.fromARGB(255, 231, 230, 230),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Nearby',
                    style: GoogleFonts.readexPro(
                        color: value == 1
                            ? Colors.white
                            : const Color.fromARGB(255, 75, 75, 75)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  value = 2;
                  FocusScope.of(context).requestFocus(FocusNode());

                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: value == 2
                          ? const Color.fromARGB(255, 104, 104, 172)
                          : const Color.fromARGB(255, 231, 230, 230),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'City Center',
                    style: GoogleFonts.readexPro(
                        color: value == 2
                            ? Colors.white
                            : const Color.fromARGB(255, 75, 75, 75)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  map(BuildContext context) {
    return ShowUp(
      delay: 600,
      child: GestureDetector(
        onTap: () async {
          final availableMaps = await mapp.MapLauncher.installedMaps;

          await availableMaps.first
              .showDirections(destination: mapp.Coords(107, 106));

          /*                          await availableMaps.first.showMarker(
                            coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                            title: widget.model.name,
                          );*/
        },
        child: Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  listLocation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...[1, 2, 3, 4].map((e) {
          var index = [1, 2, 3, 4].indexOf(e);
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 100,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location ${index + 1}",
                            style: GoogleFonts.readexPro(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Hùng Vương, Vĩnh Ninh, Thừa Thiên Huế",
                            style: GoogleFonts.readexPro(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.black45),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 250, 249, 249),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    offset: const Offset(2, 2),
                                    color: Colors.grey.withOpacity(0.1))
                              ]),
                          child: Transform.rotate(
                            angle: 45,
                            child: const Icon(
                              Icons.navigation_outlined,
                              color: Color.fromARGB(255, 104, 104, 172),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}
