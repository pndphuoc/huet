import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:hue_t/view/Foodstore/foodstore.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:hue_t/home.dart';
import 'package:hue_t/accommodation_views/hotel.dart';
import 'package:hue_t/view/profileuser/profile_user.dart';
import 'colors.dart' as colors;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(), // Wrap your app
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
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
        .pushReplacement(CupertinoPageRoute(builder: (ctx) => HueT())));
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
                    children: const [
                      SpinKitThreeBounce(
                        color: Colors.white,
                        duration: Duration(milliseconds: 1000),
                        size: 40,
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}

class HueT extends StatefulWidget {
  const HueT({super.key, this.index});
  final int? index;
  @override
  State<HueT> createState() => _HueTState();
}

class _HueTState extends State<HueT> {
  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );

  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;

  EdgeInsets padding = const EdgeInsets.only(left: 12, right: 12, bottom: 12);

  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;

  bool showUnselectedLabels = false;

  Color selectedColor = Colors.black;

  Color unselectedColor = Colors.blueGrey;

  Gradient selectedGradient =
  const LinearGradient(colors: [Colors.red, Colors.amber]);

  Gradient unselectedGradient =
  const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

  Color? containerColor;

  List<Color> containerColors = [
    const Color(0xFFFDE1D7),
    const Color(0xFFE4EDF5),
    const Color(0xFFE7EEED),
    const Color(0xFFF4E4CE),
  ];

  int _selectedItemPosition = 2;
  final List<Widget> _children = [
    HotelPage(),
    Foodstore(),
    HomePage(),
    //SocialNetWorkPage(),
    ProfileUser()
  ];

  bottomNavigationBar(BuildContext context) {
    return SnakeNavigationBar.color(
      behaviour: snakeBarStyle,
      snakeShape: snakeShape,
      shape: bottomBarShape,
      padding: padding,
      backgroundColor: colors.navigationBarColor,

      ///configuration for SnakeNavigationBar.color
      snakeViewColor: colors.primaryColor,
      selectedItemColor:
      snakeShape == SnakeShape.indicator ? selectedColor : null,
      unselectedItemColor: Colors.black,

      ///configuration for SnakeNavigationBar.gradient
      //snakeViewGradient: selectedGradient,
      //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
      //unselectedItemGradient: unselectedGradient,

      showUnselectedLabels: showUnselectedLabels,
      showSelectedLabels: showSelectedLabels,

      currentIndex: _selectedItemPosition,
      onTap: (index) => setState(() => _selectedItemPosition = index),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.hotel_outlined),
            label: 'Accommodations',
            activeIcon: Icon(Icons.hotel)),
        BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Food stores',
            activeIcon: Icon(Icons.fastfood)),
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home)),
        BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Social network',
            activeIcon: Icon(Icons.camera_alt)),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Personal Infomation',
            activeIcon: Icon(Icons.person)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      setState(() {
        _selectedItemPosition = widget.index!;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hue Travel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(children: [
            _children[_selectedItemPosition],
            MediaQuery.of(context).viewInsets.bottom != 0.0
                ? Container()
                : Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return ShowUp(
                      child: bottomNavigationBar(context), delay: 0);
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
