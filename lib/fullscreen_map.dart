import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'model/locationModel.dart';

class FullscreenMap extends StatefulWidget {
  const FullscreenMap({Key? key, required this.hotelLocation})
      : super(key: key);
  final location hotelLocation;

  @override
  State<FullscreenMap> createState() => _FullscreenMapState();
}

class _FullscreenMapState extends State<FullscreenMap> {
  final List<Marker> _markers = <Marker>[];

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(16.462766512813303, 107.58981951625772),
    zoom: 14.4746,
  );
  Completer<GoogleMapController> _controller = Completer();

  Future<Position> getUserCurrentLocation() async {
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
    _markers.add(Marker(
        markerId: MarkerId("3"),
        position: LatLng(
            widget.hotelLocation!.latitude, widget.hotelLocation!.longitude),
        infoWindow: InfoWindow(title: "Hotel's Locations")));
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
          position: LatLng(
              widget.hotelLocation!.latitude, widget.hotelLocation!.longitude),
          infoWindow: InfoWindow(title: "Hotel's Locations")));

      double miny = (value.latitude <= widget.hotelLocation!.latitude)
          ? value.latitude
          : widget.hotelLocation!.latitude;
      double minx = (value.longitude <= widget.hotelLocation!.longitude)
          ? value.longitude
          : widget.hotelLocation!.longitude;
      double maxy = (value.latitude <= widget.hotelLocation!.latitude)
          ? widget.hotelLocation!.latitude
          : value.latitude;
      double maxx = (value.longitude <= widget.hotelLocation!.longitude)
          ? widget.hotelLocation!.longitude
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
              100),
        );
      });
      setState(() {});
    });
    //Direction
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapToolbarEnabled: true,
      myLocationButtonEnabled: true,
      tiltGesturesEnabled: true,
      compassEnabled: true,
      scrollGesturesEnabled: true,
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
    );
  }
}
