import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_right.dart';
import '../../colors.dart' as colors;
import '../../model/accommodation/reviewModel.dart';

class AllReviews extends StatefulWidget {
  const AllReviews({Key? key, required this.hotelId}) : super(key: key);
  final int hotelId;

  @override
  State<AllReviews> createState() => _AllReviewsState();
}

List<reviewModel> reviewsList = [
  reviewModel(
      id: 1,
      userId: 1,
      rating: 3,
      review: "Khách sạn có ma",
      images: [
        "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
      ],
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(
      id: 2,
      userId: 1,
      rating: 4,
      review: "Normal",
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(
      id: 3,
      userId: 1,
      rating: 1,
      review: "Too bad",
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(
      id: 1,
      userId: 1,
      rating: 5,
      review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      images: [
        "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
      ],
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(
      id: 1,
      userId: 1,
      rating: 5,
      review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      images: [
        "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
      ],
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(
      id: 1,
      userId: 1,
      rating: 5,
      review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      images: [
        "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
      ],
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
  reviewModel(
      id: 1,
      userId: 1,
      rating: 5,
      review: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      images: [
        "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg"
      ],
      reviewDate: DateTime(2022, 11, 15, 12, 56)),
];

class _AllReviewsState extends State<AllReviews> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: colors.primaryColor,
              title: const Text('Reviews'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: <Tab>[
                  const Tab(text: 'All reviews'),
                  const Tab(text: 'Photos/Videos'),
                  Tab(
                      child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(text: "Rating "),
                      WidgetSpan(child: Icon(Icons.keyboard_arrow_down))
                    ]),
                  )),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ...reviewsList.map(
                        (e) => reviewsBlock(context, reviewsList.indexOf(e)))
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ...reviewsList
                        .where((element) => element.images != null)
                        .toList()
                        .map((e) =>
                            reviewsBlock(context, reviewsList.indexOf(e)))
                  ],
                ),
              ),
            ),
            const Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }

  reviewsBlock(BuildContext context, int index) {
    return ShowRight(
        delay: 100 * index,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: colors.reviewItemColor),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 30,
                    width: 30,
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/hotel/avatar.png"),
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Incognito",
                        style: GoogleFonts.readexPro(
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
                        initialRating: reviewsList[index].rating.toDouble(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(reviewsList[index].review!, style: GoogleFonts.readexPro(color: Colors.black),),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: [
                          if (reviewsList[index].images != null)
                            ...reviewsList[index].images!.map((i) => SizedBox(
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
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        reviewsList[index].reviewDate.toString(),
                        style: GoogleFonts.readexPro(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 13),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
