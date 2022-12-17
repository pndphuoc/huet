library get_user_location;

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position> getUserCurrentLocation() async {
  /*await Geolocator.requestPermission()
      .then((value) {})
      .onError((error, stackTrace) async {
    await Geolocator.requestPermission();
    print("ERROR" + error.toString());
  });*/

  if (await Permission.location.request().isGranted) {
    return await Geolocator.getCurrentPosition();
  } else {
    await Permission.location.request();
    return await Geolocator.getCurrentPosition();
  }
}
