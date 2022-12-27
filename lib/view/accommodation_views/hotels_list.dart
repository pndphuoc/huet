import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../animation/show_right.dart';
import '../../colors.dart' as colors;
import '../../model/accommodation/accommodationModel.dart';
import '../../providers/accommodation_provider.dart';
import 'hotel_detail.dart';
import 'package:hue_t/permission/get_user_location.dart' as user_location;

class HotelsPage extends StatefulWidget {
  final String idAccomodation;
  final String title;
  final String content;
  final String image;

  const HotelsPage(
      {Key? key,
      required this.idAccomodation,
      required this.title,
      required this.content,
      required this.image})
      : super(key: key);

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

bool isRecommendationHotel = true;

class _HotelsPageState extends State<HotelsPage> {
  List<hotelModel> listHotel = [];

  Future<void> distanceCaculating(Position value, List<hotelModel> list) async {
    for (int i = 0; i < list.length; i++) {
      list[i].distance = GeolocatorPlatform.instance.distanceBetween(
            value.latitude,
            value.longitude,
            list[i].accommodationLocation.latitude,
            list[i].accommodationLocation.longitude,
          ) /
          1000;
    }
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var accommodationProvider = Provider.of<AccomodationProvider>(context);

    if (isLoading) {
      (() async {
        listHotel =
            await accommodationProvider.filter(widget.idAccomodation, 100);

        await user_location.getUserCurrentLocation().then((value) async {
          await distanceCaculating(value, listHotel);
        });
        setState(() {
          isLoading = false;
        });
      })();
    }
    if (isRecommendationHotel && isLoading == false) {
      listHotel.sort(
        (b, a) {
          return a.rating!.compareTo(b.rating!);
        },
      );
    } else if (isLoading == false && isRecommendationHotel == false) {
      listHotel.sort(
        (a, b) {
          return a.distance!.compareTo(b.distance!);
        },
      );
    }
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: colors.primaryColor, size: 50),
            )
          : Stack(
              children: [contentBlock(context), backButton(context)],
            ),
    );
  }

  contentBlock(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          banner(context),
          const SizedBox(
            height: 15,
          ),
          descriptionBlock(context),
          const SizedBox(
            height: 15,
          ),
          sortBlock(context),
          const SizedBox(
            height: 15,
          ),
          ...listHotel.map((e) => hotelItem(context, listHotel.indexOf(e)))
        ],
      ),
    );
  }

  backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(top: 40, left: 20),
      child: IconButton(
          onPressed: () {
            isLoading = true;
            isRecommendationHotel = true;

            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))))),
    );
  }

  sortBlock(BuildContext context) {
    return ShowUp(
      delay: 200,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: colors.accommodationItemColor,
            borderRadius: BorderRadius.circular(25)),
        child: Stack(children: [
          /*AnimatedContainer(duration: Duration(milliseconds: 500),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(25)
            ),
            width: double.infinity/2,
            height: double.infinity,

            child: Container(),
          ),*/
          LayoutBuilder(builder: (ctx, constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(
                  left: isRecommendationHotel ? 5 : constraints.maxWidth * 0.5,
                  top: 5,
                  bottom: 5,
                  right: 5),
              height: constraints.maxHeight,
              width: constraints.maxWidth * 0.5,
              child: Container(
                decoration: BoxDecoration(
                    color: colors.filterItemColor,
                    borderRadius: BorderRadius.circular(25)),
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent)),
                        onPressed: () {
                          setState(() {
                            isRecommendationHotel = true;
                          });
                        },
                        child: Text(
                          "Recommendation",
                          style: isRecommendationHotel == true
                              ? GoogleFonts.readexPro(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.w600)
                              : GoogleFonts.readexPro(color: Colors.black),
                        ))),
              ),
              Expanded(
                  child: SizedBox(
                      child: TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              isRecommendationHotel = false;
                            });
                          },
                          child: Text(
                            "Near to you",
                            style: isRecommendationHotel == false
                                ? GoogleFonts.readexPro(
                                    color: colors.primaryColor,
                                    fontWeight: FontWeight.w600)
                                : GoogleFonts.readexPro(color: Colors.black),
                          ))))
            ],
          ),
        ]),
      ),
    );
  }

  banner(BuildContext context) {
    return ShowUp(
      delay: 0,
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(widget.image),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter)),
      ),
    );
  }

  descriptionBlock(BuildContext context) {
    return ShowUp(
      delay: 100,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            children: [
              Text(
                widget.title,
                style: GoogleFonts.readexPro(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text(widget.content,
                  style: GoogleFonts.readexPro(
                      fontSize: 15, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  hotelItem(BuildContext context, int index) {
    return ShowRight(
      delay: 300 + index * 100,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              // do something
              return HotelDetail(model: listHotel[index]);
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
                    child: CachedNetworkImage(
                      imageUrl: listHotel[index].image.toString(),
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
                          listHotel[index].name,
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
                              initialRating: listHotel[index].rating != null
                                  ? listHotel[index].rating!
                                  : 0,
                            ),
                          ),
                          const TextSpan(text: " "),
                          TextSpan(
                              text: listHotel[index].rating != null
                                  ? listHotel[index].rating!.toString()
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
                              text: listHotel[index].distance != null
                                  ? " ${listHotel[index].distance!.toStringAsFixed(2)} km"
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
                              text: "${listHotel[index].price} VND",
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
    );
  }
}
