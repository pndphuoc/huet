import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hue_t/view/Foodstore/foodstore.dart';
import 'package:hue_t/view/foodstore/foodstoredetail.dart';

void main() => runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: FoodstoreDetail(),
    );
  }
}
