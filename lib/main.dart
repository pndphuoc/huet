import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:hue_t/home.dart';
import 'package:hue_t/accommodation_views/hotel.dart';
import 'accommodation_views/homestays_list.dart';
import 'accommodation_views/hotels_list.dart';
import 'accommodation_views/resorts_list.dart';
import 'colors.dart' as colors;
void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    HomestaysPage(),
    HomePage(),
    ResortsPage(),
    HotelsPage()
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

      currentIndex:  _selectedItemPosition,
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
            icon: Icon(Icons.place_outlined),
            label: 'Tourist attraction',
            activeIcon: Icon(Icons.place)),
        BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Social network',
            activeIcon: Icon(Icons.camera_alt)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hue Travel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(children: [
          _children[_selectedItemPosition],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return bottomNavigationBar(context);
              },
            ),
          )
        ]),
      ),
    );
  }
}
