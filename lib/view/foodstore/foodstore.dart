import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/providers/foodstore_provider.dart';
import 'package:hue_t/view/foodstore/foodstoredetail.dart';
import 'package:hue_t/view/foodstore/search_foodstore.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../permission/get_user_location.dart' as user_location;

import '../../model/foodstore/restaurant.dart';

class Category {
  String? id;
  String? name;
  String? image;
  Color? color;
  Category({this.id, this.name, this.image, this.color});
}

class Foodstore extends StatefulWidget {
  const Foodstore({Key? key}) : super(key: key);

  @override
  State<Foodstore> createState() => _FoodstoreState();
}

class _FoodstoreState extends State<Foodstore> {
  var popular1 = true;
  // bool isloading = true;
  String address = "";
  List<Category> categories = [
    Category(
        id: '3',
        name: "Coffee",
        image: "assets/images/foodstore/category/1.png",
        color: const Color.fromARGB(255, 227, 245, 223)),
    Category(
        id: '4',
        name: "Specialty food",
        image: "assets/images/foodstore/category/2.png",
        color: const Color.fromARGB(255, 252, 225, 232)),
    Category(
        id: '1',
        name: "Popular restaurant",
        image: "assets/images/foodstore/category/4.png",
        color: const Color.fromARGB(255, 225, 233, 248)),
    Category(
        id: '2',
        name: "Luxury restaurant",
        image: "assets/images/foodstore/category/3.png",
        color: const Color.fromARGB(255, 250, 247, 220)),
  ];
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //
  //   });
  // }
  Future<void> distanceCalculation(
      Position value, List<Restaurant> list) async {
    for (int i = 0; i < list.length; i++) {
      list[i].distance = GeolocatorPlatform.instance.distanceBetween(
            value.latitude,
            value.longitude,
            list[i].latitude,
            list[i].longitude,
          ) /
          1000;
    }
  }

  @override
  Widget build(BuildContext context) {
    var restaurantProvider = Provider.of<FoodstoreProvider>(context);

    if (restaurantProvider.isloading) {
      (() async {
        await restaurantProvider.gettop();

        await restaurantProvider.sort();
        await user_location.getUserCurrentLocation().then((value) async {
          final coordinates = Coordinates(value.latitude, value.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          restaurantProvider.addresss = addresses.first.addressLine.toString();
          await distanceCalculation(value, restaurantProvider.list);
        });
        setState(() {
          restaurantProvider.isloading = false;
        });
      })();
    }
    address = restaurantProvider.addresss;

    return Scaffold(
      body: restaurantProvider.isloading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: color.primaryColor, size: 50),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 5),
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
            ),
    );
  }

  header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.4)),
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
                Text(
                  "HUE FOOD",
                  style: GoogleFonts.readexPro(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 45,
                  height: 45,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onSubmitted: (value) {
              if (value != "") {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchFoodStore(value: "0", searchValue: value)));
                });
              }
            },
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 240, 237, 237),
                hintText: "Search foodstore ...",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 205, 205)),
                prefixIcon: Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                      width: 0.2, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(
                        width: 0.2,
                        color: Color.fromARGB(255, 255, 255, 255)))),
          )
        ],
      ),
    );
  }

  category(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Category",
                style: GoogleFonts.readexPro(
                    fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 25),
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...categories.map((e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchFoodStore(
                                    value: e.id.toString(),
                                    searchValue: "",
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      width: 160,
                      decoration: BoxDecoration(
                          color: e.color as Color,
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        children: [
                          Positioned(
                              top: 10,
                              left: 10,
                              child: Text(e.name.toString(),
                                  style: GoogleFonts.readexPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))),
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
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }

  nearby(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nearby Store",
                  style: GoogleFonts.readexPro(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              Text("",
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 104, 104, 172)))
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.location_on_outlined,
                size: 18, color: Color.fromARGB(255, 102, 102, 102)),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Text("My Location: $address",
                  maxLines: 2,
                  style: GoogleFonts.readexPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 87, 86, 86))),
            )
          ]),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(bottom: 15),
            width: MediaQuery.of(context).size.width,
            height: 280,
            child: Consumer<FoodstoreProvider>(
              builder: (context, value, child) => ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...value.list.map((e) {
                    var index = value.list.indexOf(e);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodstoreDetail(item: e)));
                      },
                      child: BounceInDown(
                        delay: const Duration(milliseconds: 600),
                        from: 50,
                        duration: Duration(milliseconds: 700 + index * 300),
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, bottom: 10),
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(
                                    3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: CachedNetworkImage(
                                        imageUrl: e.image.toString(),
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
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.readexPro(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Opening",
                                                  style: GoogleFonts.readexPro(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.lightGreen)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: Color.fromARGB(
                                                            255, 247, 95, 95),
                                                        size: 14,
                                                      ),
                                                      Text(
                                                          e.distance?.toStringAsFixed(
                                                                      2) !=
                                                                  null
                                                              ? "${e.distance!.toStringAsFixed(2)} km"
                                                              : "km",
                                                          style: GoogleFonts
                                                              .readexPro(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ],
                                                  ),
                                                  Text(
                                                    "|",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey
                                                            .withOpacity(0.6)),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .person_pin_outlined,
                                                        size: 15,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(e.checkin.toString(),
                                                          style: GoogleFonts
                                                              .readexPro(
                                                            fontSize: 13,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: const Color.fromARGB(
                                                  255, 255, 177, 59)
                                              .withOpacity(0.8),
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          (e.rating! - 5).toStringAsFixed(1),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  popular(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
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
                      decoration: const BoxDecoration(),
                      child: Center(
                        child: Text("Hot",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: popular1
                                    ? const Color.fromARGB(255, 104, 104, 172)
                                    : const Color.fromARGB(255, 87, 86, 86))),
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
                      child: Center(
                        child: Text("Rating",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: !popular1
                                    ? const Color.fromARGB(255, 104, 104, 172)
                                    : const Color.fromARGB(255, 97, 97, 97))),
                      ),
                    ),
                  )
                ],
              ),
              AnimatedPositioned(
                  bottom: 0,
                  left: popular1 ? 0 : MediaQuery.of(context).size.width / 2,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 104, 104, 172)))),
                  ))
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          popular1
              ? SingleChildScrollView(
                  child: Consumer<FoodstoreProvider>(
                    builder: (context, value, child) => Column(
                      children: [
                        ...value.list.map((e) {
                          var index = value.list.indexOf(e);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FoodstoreDetail(item: e)));
                            },
                            child: BounceInLeft(
                              from: 150,
                              delay: const Duration(milliseconds: 500),
                              duration:
                                  Duration(milliseconds: 700 + index * 300),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 120,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                            imageUrl: e.image.toString(),
                                            height: double.infinity,
                                            width: 90,
                                            fit: BoxFit.cover),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(e.title.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.readexPro(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      size: 15,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                        (e.rating! - 5)
                                                            .toStringAsFixed(1),
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey))
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0, right: 10),
                                                  child: Text(
                                                    "|",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 17),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                        e.distance?.toStringAsFixed(
                                                                    2) !=
                                                                null
                                                            ? "${e.distance!.toStringAsFixed(2)} km"
                                                            : "km",
                                                        style: GoogleFonts
                                                            .readexPro(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0, right: 10),
                                                  child: Text(
                                                    "|",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Text("Closing",
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                247,
                                                                69,
                                                                62)))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  size: 25,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Checkin: ${e.checkin}",
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                100,
                                                                99,
                                                                99)))
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Consumer<FoodstoreProvider>(
                    builder: (context, value, child) => Column(
                      children: [
                        ...value.sort().map((e) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FoodstoreDetail(item: e)));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 120,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                            imageUrl: e.image.toString(),
                                            height: double.infinity,
                                            width: 90,
                                            fit: BoxFit.cover),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(e.title.toString(),
                                                style: GoogleFonts.readexPro(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      size: 17,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                        (e.rating! - 5)
                                                            .toStringAsFixed(1),
                                                        style: GoogleFonts
                                                            .readexPro(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey))
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
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
                                                    const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 17),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                        e.distance?.toStringAsFixed(
                                                                    2) !=
                                                                null
                                                            ? "${e.distance!.toStringAsFixed(2)} km"
                                                            : "km",
                                                        style: GoogleFonts
                                                            .readexPro(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ))
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0, right: 10),
                                                  child: Text(
                                                    "|",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Text("Closing",
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                247,
                                                                69,
                                                                62)))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  size: 25,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Checkin: ${e.checkin}",
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                100,
                                                                99,
                                                                99)))
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
                  ),
                )
        ],
      ),
    );
  }
}
