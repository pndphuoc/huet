import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart' as colors;
import 'model/reviewModel.dart';

class AllReviews extends StatefulWidget {
  const AllReviews({Key? key, required this.hotelId}) : super(key: key);
  final int hotelId;

  @override
  State<AllReviews> createState() => _AllReviewsState();
}

List<reviewModel> reviewsList = [
  reviewModel(
      id: 1,
      rating: 5,
      review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      images: [
        "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
      ],
      reviewDate: DateTime(2022, 11, 15, 12, 56)
  ),
  reviewModel(id: 2, rating: 4, review: "Normal", reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(id: 3, rating: 1, review: "Too bad", reviewDate: DateTime(2022, 11, 15, 12, 56))
];

class _AllReviewsState extends State<AllReviews> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reviews"),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("All"),
              ),
              Tab(
                child: Text("Photos/videos"),
              ),
              Tab(
                child: Text("Rating"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ...reviewsList.map((e) => reviewsBlock(context, e))
                  ],
                ),
              ),
            ),
            Icon(Icons.directions_transit, size: 350),
            Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }

  reviewsBlock(BuildContext context, reviewModel e) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors.reviewItemColor),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(right: 10),
                height: 30,
                width: 30,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/hotel/avatar.png"),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Incognito",
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  RatingBar(
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: colors.starsReviewColor,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: colors.starsReviewColor,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: colors.starsReviewColor,
                        )),
                    onRatingUpdate: (rating) {},
                    itemSize: 15,
                    allowHalfRating: true,
                    initialRating: e.rating.toDouble(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(e.review!),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      if (e.images != null)
                        ...e.images!.map((i) => Container(
                              width: 70,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      i,
                                      fit: BoxFit.fitHeight,
                                    )),
                              ),
                            ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
