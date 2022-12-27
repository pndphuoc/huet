import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:hue_t/providers/accommodation_provider.dart';
import 'package:hue_t/providers/event_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../animation/show_right.dart';
import 'package:hue_t/colors.dart' as color;

import 'evant_detail.dart';
import '../../fake_data.dart' as faker;
import 'package:hue_t/permission/get_user_location.dart' as user_location;

class SearchEventPage extends StatefulWidget {
  final String value;
  const SearchEventPage({Key? key, required this.value}) : super(key: key);

  @override
  State<SearchEventPage> createState() => _SearchEventPageState();
}

class _SearchEventPageState extends State<SearchEventPage> {
  Future<void> distanceCalculation(Position value) async {
    for (int i = 0; i < faker.listHotels.length; i++) {
      faker.listHotels[i].distance =
          GeolocatorPlatform.instance.distanceBetween(
                value.latitude,
                value.longitude,
                faker.listHotels[i].accommodationLocation.latitude,
                faker.listHotels[i].accommodationLocation.longitude,
              ) /
              1000;
    }
  }

  bool isloading = true;
  bool isloading2 = true;

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context);

    if (isloading) {
      (() async {
        await eventProvider.searchItem(widget.value);
        setState(() {
          isloading = false;
          isloading2 = false;
        });
      })();
    }
    if (isloading2) {
      (() async {
        setState(() {
          isloading2 = false;
        });
      })();
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                child: Column(
                  children: [
                    search(context),
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
            Consumer<EventProvider>(
              builder: (context, value2, child) => Expanded(
                child: TextField(
                  onChanged: (value1) async {
                    await value2.searchItem(value1);
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
            ),
          ],
        ));
  }

  result(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Consumer<AccomodationProvider>(
        builder: (context, value, child) => Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            ...value.listSearch
                .map((e) => hotelItem(context, value.listSearch.indexOf(e)))
          ],
        ),
      ),
    );
  }

  hotelItem(BuildContext context, int index) {
    return ShowRight(
      delay: 300 + index * 100,
      child: Consumer<EventProvider>(
          builder: (context, value, child) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ...value.listSearch.map((e) {
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
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
              )),
    );
  }
}
