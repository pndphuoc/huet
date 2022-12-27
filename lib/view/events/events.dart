import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/providers/event_provider.dart';
import 'package:hue_t/view/events/evant_detail.dart';
import 'package:hue_t/view/events/search_events.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool popular1 = true;
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<EventProvider>(context);
    if (productProvider.isloading) {
      (() async {
        await productProvider.getAll();
        await productProvider.getThisMonth();
        await productProvider.getNextMonth();

        setState(() {
          productProvider.isloading = false;
        });
      })();
    }
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: productProvider.isloading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: color.primaryColor, size: 50),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  children: [
                    header(context),
                    upcomingEvents(context),
                    nextMonthEvents(context)
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
                  "HUE EVENTS",
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
          TextField(
            onSubmitted: (value) {
              if (value != "") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchEventPage(value: value)));
              }
            },
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 240, 237, 237),
                hintText: "Search event ...",
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

  upcomingEvents(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcoming Event",
                      style: GoogleFonts.readexPro(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "",
                      style: GoogleFonts.readexPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 104, 104, 172)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              popular1 = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 4,
                            height: 40,
                            decoration: const BoxDecoration(),
                            child: Text("Next Month",
                                style: GoogleFonts.readexPro(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: popular1
                                        ? const Color.fromARGB(
                                            255, 104, 104, 172)
                                        : const Color.fromARGB(
                                            255, 87, 86, 86))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              popular1 = false;
                            });
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  //TOTO:BUG
                                  return alertDialog(context);
                                });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 4,
                            height: 40,
                            decoration: const BoxDecoration(),
                            child: Text("Expired",
                                style: GoogleFonts.readexPro(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: !popular1
                                        ? const Color.fromARGB(
                                            255, 104, 104, 172)
                                        : const Color.fromARGB(
                                            255, 97, 97, 97))),
                          ),
                        )
                      ],
                    ),
                    AnimatedPositioned(
                        bottom: 0,
                        left: popular1
                            ? 0
                            : MediaQuery.of(context).size.width / 4,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 2,
                                      color:
                                          Color.fromARGB(255, 104, 104, 172)))),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: Consumer<EventProvider>(
              builder: (context, value, child) => Swiper(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => EventDetail(
                                item: value.listNextMonth[index])))),
                    child: FadeIn(
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  blurStyle: BlurStyle.normal,
                                  offset: const Offset(3, 3))
                            ]),
                        child: Column(
                          children: [
                            Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: value.listNextMonth[index].image
                                      .toString(),
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  bottom: -1,
                                  child: SizedBox(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width - 85,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5.0, sigmaY: 5.0),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.3),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  value
                                                      .listNextMonth[index].name
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: GoogleFonts.readexPro(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  value.listNextMonth[index]
                                                      .begin
                                                      .toString()
                                                      .split("T")[0],
                                                  style: GoogleFonts.readexPro(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white
                                                          .withOpacity(0.6)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ]),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Expanded(
                                          child: Text(
                                            value.list[index].address
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.readexPro(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                viewportFraction: 0.8,
                scale: 0.9,
                itemCount: value.listNextMonth.length,
                autoplay: true,
                autoplayDelay: 5000,
              ),
            ),
          )
        ],
      ),
    );
  }

  nextMonthEvents(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20.0, right: 20, bottom: 20),
          child: Consumer<EventProvider>(
            builder: (context, value, child) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "This Month Event",
                      style: GoogleFonts.readexPro(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "",
                      style: GoogleFonts.readexPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 104, 104, 172)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ...value.listThisMonth.map((e) {
                  var index = value.list.indexOf(e);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetail(item: e)));
                    },
                    child: BounceInLeft(
                      duration: Duration(milliseconds: 1500 + 300 * index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 5),
                                blurRadius: 10,
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                    imageUrl: e.image.toString(),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Text(e.name.toString(),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style: GoogleFonts.readexPro(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        e.address.toString(),
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: GoogleFonts.readexPro(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                  child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.grey,
                              ))
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
        ),
      ],
    );
  }

  Widget alertDialog(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 200),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Haven't Events Expired",
                style: GoogleFonts.readexPro(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      popular1 = true;
                      Navigator.of(context).pop(false);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, top: 15, bottom: 15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    "Ok",
                    style: GoogleFonts.readexPro(color: Colors.grey),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
