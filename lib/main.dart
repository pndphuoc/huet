import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((value) => Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (ctx) => Foodstore())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/splashscreen/3.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 330,
              child: Image.asset(
                'assets/images/splashscreen/5.png',
                width: MediaQuery.of(context).size.width,
              )),
          Positioned(
              top: 100,
              child: ElasticInUp(
                duration: Duration(milliseconds: 3000),
                child: Image.asset(
                  'assets/images/splashscreen/2.png',
                  width: MediaQuery.of(context).size.width,
                ),
              )),
          Positioned(
              top: 700,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: Colors.white,
                      duration: Duration(milliseconds: 1000),
                      size: 40,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
