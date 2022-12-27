import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import '../../animation/show_up.dart';
import '../../permission/get_user_location.dart' as userLocation;
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import '../../constants/user_info.dart' as user_constants;
import '../../providers/favorite_provider.dart';

String formatHtmlString(String string) {
  var unescape = HtmlUnescape();
  var text = unescape.convert(string);
  return text;
}

// ignore: must_be_immutable
class TouristAttractionDetail extends StatefulWidget {
  TouristAttraction item;
  TouristAttractionDetail({super.key, required this.item});

  @override
  State<TouristAttractionDetail> createState() =>
      _TouristAttractionDetailState();
}

class _TouristAttractionDetailState extends State<TouristAttractionDetail> {
  bool visible = false;
  late GoogleMapController mapController;
  bool isFavorite = false;

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
    var favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    user_constants.user == null
        ? isFavorite = false
        : isFavorite =
            favoriteProvider.checkFavorite(widget.item.id.toString());
    userLocation.getUserCurrentLocation().then((value) async {
      // marker added for hotels location

      _markers.add(Marker(
          markerId: const MarkerId("3"),
          position: LatLng(widget.item.latitude, widget.item.longitude),
          infoWindow: const InfoWindow(title: "Hotel's Locations")));

      double miny = (value.latitude <= widget.item.latitude)
          ? value.latitude
          : widget.item.latitude;
      double minx = (value.longitude <= widget.item.longitude)
          ? value.longitude
          : widget.item.longitude;
      double maxy = (value.latitude <= widget.item.latitude)
          ? widget.item.latitude
          : value.latitude;
      double maxx = (value.longitude <= widget.item.longitude)
          ? widget.item.longitude
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
      // ignore: unused_element
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
      body: Stack(children: [
        Container(
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
                                widget.item.id.toString(),
                                widget.item.title.toString(),
                                widget.item.address.toString(),
                                widget.item.image.toString(),
                                3,
                                user_constants.user!.uid);
                          } else {
                            setState(() {
                              isFavorite = !isFavorite;
                              value.deleteFavorite(widget.item.id.toString(), 3,
                                  user_constants.user!.uid);
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
    );
  }

  Widget header(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: CachedNetworkImage(
          imageUrl: "https://khamphahue.com.vn/${widget.item.image}",
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
          bottom: 120,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: widget.item.images!.split(",").length >= 4
                    ? MediaQuery.of(context).size.width / 1.4
                    : widget.item.images!.split(",").length * 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...widget.item.images!.split(",").map((e) {
                        var index = widget.item.images!.split(",").indexOf(e);
                        if (index < 4) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: "https://khamphahue.com.vn/$e",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox(
                            width: 0,
                            height: 0,
                          );
                        }
                      })
                    ],
                  ),
                ),
              ),
            ),
          ))
    ]);
  }

  Widget body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 300),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: GoogleFonts.readexPro(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
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
                      child: Text(widget.item.address,
                          maxLines: 2,
                          style: GoogleFonts.readexPro(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 109, 109, 109))),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final availableMaps =
                        await map_launcher.MapLauncher.installedMaps;

                    await availableMaps.first.showDirections(
                        destination: map_launcher.Coords(
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
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(0.3)))),
            ),
            descripton(context),
            map(context)
          ],
        ),
      ),
    );
  }

  Widget descripton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final Size sizeFull = (TextPainter(
      text: TextSpan(
        text: widget.item.description != null
            ? widget.item.description.toString().replaceAll('\n', '')
            : parse(widget.item.htmldescription.toString())
                .documentElement!
                .text
                .replaceAll('\n', ''),
        style: GoogleFonts.readexPro(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87.withOpacity(0.6)),
      ),
      textScaleFactor: mediaQuery.textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;

    final numberOfLinebreaks = widget.item.description != null
        ? widget.item.description.toString().split('\n').length
        : parse(widget.item.htmldescription.toString())
            .documentElement!
            .text
            .split('\n')
            .length;

    final numberOfLines =
        (sizeFull.width / (mediaQuery.size.width)).ceil() + numberOfLinebreaks;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: GoogleFonts.readexPro(
                fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width,
                height: visible ? sizeFull.height * (numberOfLines + 1) : 150,
                child: Text(
                  widget.item.description != null
                      ? widget.item.description.toString()
                      : parse(widget.item.htmldescription)
                          .documentElement!
                          .text,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87.withOpacity(0.6)),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                  child: Text(visible ? 'Thu nhỏ' : 'Xem thêm',
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 104, 104, 172))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget map(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Map",
            style: GoogleFonts.readexPro(
                fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          ShowUp(
            delay: 600,
            child: GestureDetector(
              onTap: () async {
                final availableMaps =
                    await map_launcher.MapLauncher.installedMaps;

                await availableMaps.first.showDirections(
                    destination: map_launcher.Coords(
                        widget.item.latitude, widget.item.longitude));

                /*                          await availableMaps.first.showMarker(
                            coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                            title: widget.model.name,
                          );*/
              },
              child: SizedBox(
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
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.7)),
                          child: Text(
                            "Click to open direction in Google Map",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: color.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
