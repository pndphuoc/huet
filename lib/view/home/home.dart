import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/accommodation_views/hotel.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/main.dart';
import 'package:hue_t/providers/weather_provider.dart';
import 'package:hue_t/view/events/events.dart';
import 'package:hue_t/view/foodstore/foodstore.dart';
import 'package:hue_t/view/sign_in_out/sign_in_page.dart';
import 'package:hue_t/view/tourist_attraction/tourist_attraction.dart';
import 'package:provider/provider.dart';
import '../../constants/user_info.dart' as user_constants;
import 'package:hue_t/view/profileuser/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  bool users = true;
  int _currentIndex = 0;
  final bool _visible = true;
  List listSlider = [
    "https://tienganhthayquy.com/wp-content/uploads/2021/01/tu-vung-ve-events-1.jpg",
    "https://thuathienhue.gov.vn/Portals/0/MINH2022/M_20220701_phaohoa.jpg",
    "https://bcp.cdnchinhphu.vn/zoom/600_315/Uploaded/duongphuonglien/2014_09_02/02092014tcq12111017385.jpg",
  ];

  // @override
  // initState() {
  //   super.initState();
  //   // Add listeners to this class
  //   Timer(
  //       const Duration(seconds: 5),
  //       () => setState(() {
  //             _visible = !_visible;
  //             Timer(
  //                 const Duration(milliseconds: 5400),
  //                 () => setState(() {
  //                       _visible = !_visible;
  //                     }));
  //           }));
  // }

  @override
  Widget build(BuildContext context) {
    if(user_constants.user != null) {
      print("TAI HOME: ${user_constants.user!.uid}");
    }
    var weatherProvider = Provider.of<WeatherProvider>(context);
    if (weatherProvider.isloading) {
      (() async {
        await weatherProvider.getWeather();
        setState(() {
          weatherProvider.isloading = false;
        });
      })();
    }

    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(context),
            body(context),
            utilities(context),
            slider(context)
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Stack(children: [
      Stack(children: [
        Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: 240,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: Stack(children: [
                Image.asset(
                  'assets/images/home/2.jpg',
                  height: 210,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -15,
                  right: 10,
                  child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visible,
                    child: Image.network(
                      "https://media3.giphy.com/media/3BkLpzHRvGoqRJewjs/giphy.gif?cid=ecf05e47xnj76fq170c4x6dgq4dgyfvn9w96v1gf8y8v5v4b&rid=giphy.gif&ct=s",
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -13,
                  left: 0,
                  child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visible,
                    child: Image.network(
                      "https://media4.giphy.com/media/17oVc5zm3lpcMDBBzK/giphy.gif?cid=ecf05e47f1j4vw6s8gm917hiyf1bx0ow2xfu7gipem590xwx&rid=giphy.gif&ct=s",
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ]),
            )),
        Positioned(
            left: 35,
            top: 70,
            child: Stack(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 40),
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: user_constants.user == null
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthService()
                                      .handleAuthState(
                                          const HueT(), const SignInPage())),
                              (route) => false);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(left: 35),
                          width: 150,
                          height: 45,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 165, 165, 250),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lock_open_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Đăng nhập",
                                  style: GoogleFonts.readexPro(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(left: 40),
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user_constants.user!.name,
                                style: GoogleFonts.readexPro(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            const SizedBox(
                              height: 3,
                            ),
                            Text("Chào mừng bạn đến với Huế Travel",
                                style: GoogleFonts.readexPro(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.7))),
                          ],
                        ),
                      ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(
                      user_constants.user == null
                          ? "https://st3.depositphotos.com/13159112/17145/v/600/depositphotos_171453724-stock-illustration-default-avatar-profile-icon-grey.jpg"
                          : user_constants.user!.photoURL,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ]))
      ]),
      Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                        color: Colors.grey.withOpacity(0.3))
                  ]),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.center,
                    width: (MediaQuery.of(context).size.width / 1.2) / 2 - 15,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 1,
                                color: Colors.grey.withOpacity(0.4)))),
                    child: Row(
                      children: [
                        Image.network(
                          "https://product.hstatic.net/200000122283/product/c-e1-bb-9d-vi-e1-bb-87t-nam_2c0683597d2d419fac401f51ccbae779_grande.jpg",
                          width: 40,
                          height: 25,
                          filterQuality: FilterQuality.low,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Hue City",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  Consumer<WeatherProvider>(
                      builder: (context, value, child) => Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      value.currentweather.main['feels_like']
                                              .toStringAsFixed(0) +
                                          "\u2103",
                                      style: GoogleFonts.readexPro(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 63, 63, 63)),
                                    ),
                                    Text(
                                      value.currentweather.weather[0]['main'],
                                      style: GoogleFonts.readexPro(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 94, 93, 93)),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Icon(
                                  Icons.wb_cloudy_outlined,
                                  size: 40,
                                  color: Color.fromARGB(255, 94, 93, 93),
                                )
                              ],
                            ),
                          ))
                ],
              ),
            ),
          ))
    ]);
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          buttonLink(
              context,
              "https://cdn-icons-png.flaticon.com/512/9198/9198907.png",
              "Ở đâu ?",
              const HotelPage()),
          buttonLink(
              context,
              "https://cdn-icons-png.flaticon.com/512/2934/2934108.png",
              "Ăn gì ?",
              const Foodstore()),
          buttonLink(
              context,
              "https://cdn-icons-png.flaticon.com/512/2972/2972857.png",
              "Đi đâu ?",
              const TouristAttraction()),
          buttonLink(
              context,
              "https://cdn-icons-png.flaticon.com/512/4612/4612366.png",
              "Có gì hot ?",
              const HueT(
                index: 3,
              )),
        ]),
      ),
    );
  }

  Widget utilities(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tiện ích",
                style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/2676/2676606.png",
                    "ATM"),
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/891/891035.png",
                    "Cây xăng"),
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/8327/8327497.png",
                    "WC Công Cộng"),
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/2401/2401174.png",
                    "Taxi"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buttonLink(
      BuildContext context, String image, String name, Widget? page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                      color: Colors.grey.withOpacity(0.1))
                ]),
            child: Center(
              child: Image.network(image),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(name,
              style: GoogleFonts.readexPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget buttonLinkSmall(BuildContext context, String image, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                    color: Colors.grey.withOpacity(0.3))
              ]),
          child: Center(
            child: Image.network(image),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 70,
          child: Center(
            child: Text(name,
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)),
          ),
        ),
      ],
    );
  }

  slider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sự kiện",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
              GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Events()),
                    (route) => false),
                child: Text("Xem tất cả",
                    style: GoogleFonts.readexPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: color.primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              height: 150.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: listSlider.map((e) {
              return Builder(builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Events())),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        e,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...listSlider.map((e) {
                int idx = listSlider.indexOf(e);
                return Container(
                  width: 5.0,
                  height: 5.0,
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == idx ? Colors.orange : Colors.grey,
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
