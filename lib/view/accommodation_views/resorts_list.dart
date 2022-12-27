import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:hue_t/providers/accommodation_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../animation/show_right.dart';
import 'package:hue_t/colors.dart' as color;

import 'hotel_detail.dart';
import '../../fake_data.dart' as faker;
import 'package:hue_t/permission/get_user_location.dart' as user_location;

class ResortsPage extends StatefulWidget {
  final String value;
  const ResortsPage({Key? key, required this.value}) : super(key: key);

  @override
  State<ResortsPage> createState() => _ResortsPageState();
}

class _ResortsPageState extends State<ResortsPage> {
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
    var accommodationProvider = Provider.of<AccomodationProvider>(context);

    if (isloading) {
      (() async {
        await accommodationProvider.searchItem(widget.value);
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
            Consumer<AccomodationProvider>(
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
      child: Consumer<AccomodationProvider>(
        builder: (context, value, child) => Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // do something
                return HotelDetail(model: value.listSearch[index]);
              }));
            },
            style: ElevatedButton.styleFrom(
                elevation: 0.0,
                shadowColor: Colors.white,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        value.listSearch[index].image.toString(),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, right: 20, bottom: 20, left: 10),
                      height: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value.listSearch[index].name,
                            style: GoogleFonts.readexPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            maxLines: 1,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            WidgetSpan(
                              child: RatingBar(
                                ratingWidget: RatingWidget(
                                    full: const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    half: const Icon(
                                      Icons.star_half,
                                      color: Colors.yellow,
                                    ),
                                    empty: const Icon(
                                      Icons.star_border,
                                      color: Colors.yellow,
                                    )),
                                onRatingUpdate: (rating) {},
                                itemSize: 15,
                                allowHalfRating: true,
                                initialRating:
                                    value.listSearch[index].rating != null
                                        ? value.listSearch[index].rating!
                                        : 0,
                              ),
                            ),
                            const TextSpan(text: " "),
                            TextSpan(
                                text: value.listSearch[index].rating != null
                                    ? value.listSearch[index].rating!.toString()
                                    : "No review",
                                style: GoogleFonts.readexPro(
                                    color: Colors.black, fontSize: 11))
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            const WidgetSpan(
                                child: Icon(
                              Icons.map_outlined,
                              size: 16,
                              color: Colors.grey,
                            )),
                            TextSpan(
                                text: value.listSearch[index].distance != null
                                    ? " ${value.listSearch[index].distance!.toStringAsFixed(2)} km"
                                    : " km",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black))
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            const WidgetSpan(
                                child: Icon(
                              Icons.attach_money,
                              size: 20,
                              color: Colors.black,
                            )),
                            TextSpan(
                                text: "${value.listSearch[index].price} VND",
                                style: GoogleFonts.readexPro(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                )),
                            TextSpan(
                                text: "/night",
                                style: GoogleFonts.readexPro(
                                    fontSize: 12, color: Colors.grey))
                          ]))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
