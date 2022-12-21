import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/providers/event_provider.dart';
import 'package:hue_t/view/events/evant_detail.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool popular1 = true;
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<EventProvider>(context);
    if (isloading) {
      (() async {
        await productProvider.getAll();
        await productProvider.getThisMonth();
        await productProvider.getNextMonth();

        setState(() {
          isloading = false;
        });
      })();
    }
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: isloading
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
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: const BoxDecoration(),
            child: Center(
                child: Text(
              "HUE EVENTS",
              style: GoogleFonts.readexPro(
                  fontSize: 22, fontWeight: FontWeight.bold),
            )),
          ),
          TextField(
            onChanged: (value) {
              setState(() {});
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
                          onTap: () {
                            setState(() {
                              popular1 = false;
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
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 20),
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
                              child: Image.network(
                                value.listNextMonth[index].image.toString(),
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                bottom: -1,
                                child: SizedBox(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width - 85,
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
                                                value.listNextMonth[index].name
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                value.listNextMonth[index].begin
                                                    .toString()
                                                    .split("T")[0],
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
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
                            padding: const EdgeInsets.only(left: 5, right: 10),
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
                                          value.list[index].address.toString(),
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
                ...value.listThisMonth.map((e) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetail(item: e)));
                      },
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
                                child: Image.network(e.image.toString(),
                                    width: 70, height: 70, fit: BoxFit.cover),
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
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
