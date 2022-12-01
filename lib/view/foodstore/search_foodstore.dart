import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/Foodstore/foodstoredetail.dart';
import 'package:hue_t/api/foodstore/food_store_api.dart' as data;
import 'package:hue_t/colors.dart' as color;
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class SearchFoodStore extends StatefulWidget {
  String searchValue;
  SearchFoodStore({super.key, required this.searchValue});

  @override
  State<SearchFoodStore> createState() => _SearchFoodStoreState();
}

class _SearchFoodStoreState extends State<SearchFoodStore> {
  bool isloading = true;
  bool isloading2 = true;
  int popular1 = 1;
  String? value;
  @override
  Widget build(BuildContext context) {
    if (isloading) {
      value = widget.searchValue;
      (() async {
        await data.search(widget.searchValue);
        await data.sort();

        setState(() {
          isloading = false;
          isloading2 = false;
        });
      })();
    }
    if (isloading2) {
      (() async {
        await data.search(value);
        await data.sort();

        setState(() {
          isloading2 = false;
        });
      })();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: Column(
                children: [
                  search(context),
                  categories(context),
                ],
              ),
            ),
            isloading2
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: color.primaryColor, size: 50),
                  )
                : result(context),
          ],
        ),
      ),
    );
  }

  search(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 241, 241),
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: color.filterItemColor,
                    hintText: "What are you cracing?",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 206, 205, 205)),
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          width: 0.2,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                            width: 0.2,
                            color: Color.fromARGB(255, 255, 255, 255)))),
              ),
            ),
          ],
        ));
  }

  result(BuildContext context) {
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
                        popular1 = 1;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 40,
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Text("Result",
                            style: GoogleFonts.readexPro(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: popular1 == 1
                                    ? Color.fromARGB(255, 104, 104, 172)
                                    : Color.fromARGB(255, 87, 86, 86))),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        popular1 = 2;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 40,
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Text("Near you",
                            style: GoogleFonts.readexPro(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: popular1 == 2
                                    ? Color.fromARGB(255, 104, 104, 172)
                                    : Color.fromARGB(255, 97, 97, 97))),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        popular1 = 3;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 40,
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Text("Rating",
                            style: GoogleFonts.readexPro(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: popular1 == 3
                                    ? Color.fromARGB(255, 104, 104, 172)
                                    : Color.fromARGB(255, 97, 97, 97))),
                      ),
                    ),
                  )
                ],
              ),
              AnimatedPositioned(
                  bottom: 0,
                  left: popular1 == 1
                      ? 0
                      : popular1 == 2
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width * 2 / 3,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
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
          popular1 == 1
              ? resultSearch(context)
              : popular1 == 2
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ...data.list.map((e) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FoodstoreDetail(item: e)));
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                              e.image.toString(),
                                              height: double.infinity,
                                              width: 90,
                                              fit: BoxFit.cover),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(e.title.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: GoogleFonts.readexPro(
                                                    fontSize: 17,
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
                                                      Text(
                                                          (e.rating! - 5)
                                                              .toStringAsFixed(
                                                                  1),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10),
                                                    child: Text(
                                                      "|",
                                                      style: TextStyle(
                                                          fontSize: 18,
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10),
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
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      247,
                                                                      69,
                                                                      62)))
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
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color
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
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...data.list2.map((e) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FoodstoreDetail(item: e)));
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                              e.image.toString(),
                                              height: double.infinity,
                                              width: 90,
                                              fit: BoxFit.cover),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(e.title.toString(),
                                                  style: GoogleFonts.readexPro(
                                                    fontSize: 17,
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
                                                      Text(
                                                          (e.rating! - 5)
                                                              .toStringAsFixed(
                                                                  1),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10),
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
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      247,
                                                                      69,
                                                                      62)))
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
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color
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
                    )
        ],
      ),
    );
  }

  categories(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              isloading2 = true;
              value = '3';
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == "3"
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Coffee',
                style: GoogleFonts.readexPro(
                    color: value == "3"
                        ? Colors.white
                        : Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isloading2 = true;
              value = '4';
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == "4"
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Specialty Food',
                style: GoogleFonts.readexPro(
                    color: value == "4"
                        ? Colors.white
                        : Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isloading2 = true;
              value = '1';
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == "1"
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Popular Restaurant',
                style: GoogleFonts.readexPro(
                    color: value == "1"
                        ? Colors.white
                        : Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isloading2 = true;
              value = '2';
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == "2"
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Luxury Restaurant',
                style: GoogleFonts.readexPro(
                    color: value == "2"
                        ? Colors.white
                        : Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          )
        ],
      ),
    );
  }

  resultSearch(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...data.listSearch.map((e) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodstoreDetail(item: e)));
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
                          child: Image.network(e.image.toString(),
                              height: double.infinity,
                              width: 90,
                              fit: BoxFit.cover),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.title.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.readexPro(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      Text((e.rating! - 5).toStringAsFixed(1),
                                          style: GoogleFonts.readexPro(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey))
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Text(
                                      "|",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
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
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                  ),
                                  Text("Closing",
                                      style: GoogleFonts.readexPro(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 247, 69, 62)))
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Checkin: " + e.checkin.toString(),
                                      style: GoogleFonts.readexPro(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 100, 99, 99)))
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
    );
  }
}
