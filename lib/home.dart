import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:hue_t/accommodation_views/homestays_list.dart';
import 'package:hue_t/accommodation_views/hotel.dart';
import 'package:hue_t/accommodation_views/hotels_list.dart';
import 'package:hue_t/accommodation_views/resorts_list.dart';
import 'bottomNavigationBar.dart' as BottomNavigationBar;
import 'colors.dart' as colors;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Home"),
    );
  }


}


