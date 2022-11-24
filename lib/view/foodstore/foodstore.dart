import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/foodstore/foodstoredetail.dart';
import 'package:hue_t/view/navigationbar/navigationbar.dart' as NavigationBar;
import 'package:hue_t/model/foodstore/restaurant.dart' as restaurant;
import 'package:hue_t/colors.dart' as color;

class Category {
  String? name;
  String? image;
  Color? color;
  Category({this.name, this.image, this.color});
}

class Foodstore extends StatefulWidget {
  const Foodstore({Key? key}) : super(key: key);

  @override
  State<Foodstore> createState() => _FoodstoreState();
}

class _FoodstoreState extends State<Foodstore> {
  var popular1 = true;
  List imageslide = [
    "assets/images/foodstore/food3.jpg",
    "assets/images/foodstore/food1.jpg",
    "assets/images/foodstore/food2.png",
    "assets/images/foodstore/food4.jpg",
  ];

  List<Category> categories = [
    Category(
        name: "Coffee",
        image: "assets/images/foodstore/category/1.png",
        color: Color.fromARGB(255, 227, 245, 223)),
    Category(
        name: "Specialty food",
        image: "assets/images/foodstore/category/2.png",
        color: Color.fromARGB(255, 252, 225, 232)),
    Category(
        name: "Popular restaurant",
        image: "assets/images/foodstore/category/4.png",
        color: Color.fromARGB(255, 225, 233, 248)),
    Category(
        name: "Luxury restaurant",
        image: "assets/images/foodstore/category/3.png",
        color: Color.fromARGB(255, 250, 247, 220)),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurant.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        color: color.backgroundColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  header(context),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 10, top: 15),
                    child: Column(
                      children: [
                        category(context),
                        nearby(context),
                      ],
                    ),
                  ),
                  popular(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  header(BuildContext context) {
    return Container(
      height: 230,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                itemBuilder: (context, index) {
                  return Image.asset(
                    imageslide[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: imageslide.length,
                autoplay: true,
                autoplayDelay: 5000,
              )),
          Positioned(
              bottom: 0,
              child: Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: color.filterItemColor,
                        hintText: "What are you cracing?",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 206, 205, 205)),
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                              width: 0.2,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                                width: 0.2,
                                color: Color.fromARGB(255, 255, 255, 255)))),
                  )))
        ],
      ),
    );
  }

  category(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Category",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...categories.map((e) => Container(
                      margin: EdgeInsets.only(right: 15),
                      width: 120,
                      decoration: BoxDecoration(
                          color: e.color as Color,
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        children: [
                          Positioned(
                              top: 10,
                              left: 10,
                              child: Text(e.name.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Image.asset(
                                e.image.toString(),
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                              ))
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  nearby(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nearby Store",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text("See All",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 104, 104, 172)))
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Icon(Icons.location_on_outlined,
                size: 20, color: Color.fromARGB(255, 102, 102, 102)),
            Text("Your Location: 102 Tuy Ly Vuong, TP Hue",
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 87, 86, 86)))
          ]),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(bottom: 15),
            width: MediaQuery.of(context).size.width,
            height: 290,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...restaurant.listrestaurant.map((e) => Container(
                      margin: EdgeInsets.only(right: 20, bottom: 10),
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: Image.asset(
                                    e.image![0].toString(),
                                    width: double.infinity,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.title.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Opening",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.lightGreen)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Color.fromARGB(
                                                        255, 247, 95, 95),
                                                    size: 14,
                                                  ),
                                                  Text("0.3km",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ],
                                              ),
                                              Text(
                                                "|",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey
                                                        .withOpacity(0.6)),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person_pin_outlined,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(e.checkin.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ))
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 255, 177, 59)
                                          .withOpacity(0.8),
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      e.rating.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  popular(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        popular1 = true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Text("Hot",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: popular1
                                    ? Color.fromARGB(255, 104, 104, 172)
                                    : Color.fromARGB(255, 87, 86, 86))),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        popular1 = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Text("Rating",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: !popular1
                                    ? Color.fromARGB(255, 104, 104, 172)
                                    : Color.fromARGB(255, 97, 97, 97))),
                      ),
                    ),
                  )
                ],
              ),
              AnimatedPositioned(
                  bottom: 0,
                  left: popular1 ? 0 : MediaQuery.of(context).size.width / 2,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 104, 104, 172)))),
                  ))
            ],
          ),
          SizedBox(
            height: 3,
          ),
          popular1
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130 * (restaurant.listrestaurant.length as double),
                  child: Column(
                    children: [
                      ...restaurant.listrestaurant.map((e) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FoodstoreDetail()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(e.image![0].toString(),
                                          height: double.infinity,
                                          width: 90,
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(e.title.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 17,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(e.rating.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.grey))
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 17),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text("0.3km")
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Text("Closing",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 247, 69, 62)))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 25,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "Checkin: " +
                                                      e.checkin.toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 100, 99, 99)))
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130 * (restaurant.listrestaurant2.length as double),
                  child: Column(
                    children: [
                      ...restaurant.listrestaurant2.map((e) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FoodstoreDetail()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(e.image![0].toString(),
                                          height: double.infinity,
                                          width: 90,
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(e.title.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 17,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(e.rating.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.grey))
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 17),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text("0.3km")
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Text("Closing",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 247, 69, 62)))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 25,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  "Checkin: " +
                                                      e.checkin.toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 100, 99, 99)))
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
