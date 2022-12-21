import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import '../../animation/show_right.dart';
import '../../colors.dart' as colors;
import 'hotel_detail.dart';
import '../../fake_data.dart' as faker;
import 'package:hue_t/permission/get_user_location.dart' as userLocation;

class HomestaysPage extends StatefulWidget {
  const HomestaysPage({Key? key}) : super(key: key);

  @override
  State<HomestaysPage> createState() => _HomestaysPageState();
}

bool isRecommendationHotel = true;

class _HomestaysPageState extends State<HomestaysPage> {
  Future<void> distanceCaculating(Position value) async {
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

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      userLocation.getUserCurrentLocation().then((value) async {
        print(value.latitude.toString() + " " + value.longitude.toString());
        await distanceCaculating(value);
        setState(() {
          isLoading = false;
        });
      });
    }
    if (isRecommendationHotel) {
      faker.listHotels.sort(
        (b, a) {
          return a.rating!.compareTo(b.rating!);
        },
      );
    } else {
      faker.listHotels.sort(
        (a, b) {
          return a.distance!.compareTo(b.distance!);
        },
      );
    }
    return Scaffold(
      body: Stack(
        children: [contentBlock(context), backButton(context)],
      ),
    );
  }

  contentBlock(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          banner(context),
          SizedBox(
            height: 15,
          ),
          descriptionBlock(context),
          SizedBox(
            height: 15,
          ),
          sortBlock(context),
          SizedBox(
            height: 15,
          ),
          ...faker.listHotels
              .map((e) => hotelItem(context, faker.listHotels.indexOf(e)))
        ],
      ),
    );
  }

  backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(top: 40, left: 20),
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
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
        margin: EdgeInsets.only(
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
              duration: Duration(milliseconds: 300),
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
                child: Container(
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
                              ? GoogleFonts.montserrat(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.w600)
                              : GoogleFonts.montserrat(color: Colors.black),
                        ))),
              ),
              Expanded(
                  child: Container(
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
                                ? GoogleFonts.montserrat(
                                    color: colors.primaryColor,
                                    fontWeight: FontWeight.w600)
                                : GoogleFonts.montserrat(color: Colors.black),
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
                image: NetworkImage(
                    "https://cdn4.tropicalsky.co.uk/images/1800x600/indochine-palace-main-image.jpg"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter)),
      ),
    );
  }

  descriptionBlock(BuildContext context) {
    return ShowUp(
      delay: 100,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            children: [
              Text(
                "Homestays",
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text("Best-rated homestays in the last month",
                  style: GoogleFonts.poppins(
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
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              // do something
              return HotelDetail(model: faker.listHotels[index]);
            }));
          },
          style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shadowColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      faker.listHotels[index].images.first,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 20, right: 20, bottom: 20, left: 10),
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          faker.listHotels[index].name,
                          style: GoogleFonts.notoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          maxLines: 1,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                            child: RatingBar(
                              ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  ),
                                  empty: Icon(
                                    Icons.star_border,
                                    color: Colors.yellow,
                                  )),
                              onRatingUpdate: (rating) {},
                              itemSize: 15,
                              allowHalfRating: true,
                              initialRating:
                                  faker.listHotels[index].rating != null
                                      ? faker.listHotels[index].rating!
                                      : 0,
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(
                              text: faker.listHotels[index].rating != null
                                  ? faker.listHotels[index].rating!.toString()
                                  : "No review",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black, fontSize: 11))
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: Colors.grey,
                          )),
                          TextSpan(
                              text: faker.listHotels[index].distance != null
                                  ? " ${faker.listHotels[index].distance!.toStringAsFixed(2)} km"
                                  : " km",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black))
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.attach_money,
                            size: 20,
                            color: Colors.black,
                          )),
                          TextSpan(
                              text: faker.listHotels[index].price.toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: "/night",
                              style: GoogleFonts.montserrat(
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
