import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_up.dart';
import 'animation/show_right.dart';
import 'colors.dart' as colors;
import 'hotel_detail.dart';
import 'model/hotelModel.dart';
import 'model/locationModel.dart';
import 'model/roomTypeModel.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HotHotelsPage extends StatefulWidget {
  const HotHotelsPage({Key? key}) : super(key: key);

  @override
  State<HotHotelsPage> createState() => _HotHotelsPageState();
}

List<roomTypeModel> roomTypesOfHuongGiangHotel = [
  roomTypeModel(id: 1, name: "Single room"),
  roomTypeModel(id: 2, name: "Double room"),
  roomTypeModel(id: 3, name: "Triple room"),
  roomTypeModel(id: 4, name: "VIP room")
];

List<String> imagesOfHuongGiangHotel = [
  'https://ak-d.tripcdn.com/images/200h0i0000009ehpzF02A_Z_1100_824_R5_Q70_D.jpg',
  'https://www.huonggianghotel.com.vn/wp-content/uploads/2018/06/DSC_4563-HDR2_1600x1068-1.jpg',
  'https://cf.bstatic.com/xdata/images/hotel/max1280x900/185016305.jpg?k=e0510db64b6c0f4b0623cb63a4014b95c677970d880c414c864fbbe094a9211c&o=&hp=1'
];

List<hotelModel> listHotels = [
  hotelModel(
      id: 1,
      name: "Silk Path Grand Hue Hotel",
      address: "2 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.458015573692116, longitude: 107.57969752805363),
      images: ["https://pix10.agoda.net/hotelImages/14694836/-1/9914bb8998c5b239d3c8ac6b8563016d.jpg?ca=13&ce=1&s=1024x768", "http://silkpathhotel.com/media/ckfinder/images/Hotel/2/Hue6789/Hue_Acco_doc.jpg", "http://silkpathhotel.com/media/ckfinder/images/Slide_mice/Hue_Mice_Banquet.jpg", "https://cdn1.ivivu.com/iVivu/2020/09/10/11/spgh-overview-2-cr-800x450.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 5),
  hotelModel(
      id: 1,
      name: "Hương Giang",
      address: "69 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.470970686019427, longitude: 107.5944807077246),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4),
  hotelModel(
      id: 2,
      name: "Vinpearl Hue",
      address: "50A Hùng Vương",
      hotelLocaton:
      location(latitude: 16.463430881885497, longitude: 107.59451227529739),
      images: ["https://statics.vinpearl.com/Hinh-anh-review-vinpearl-Hu%E1%BA%BF.jpg", "https://cdn1.ivivu.com/iVivu/2019/04/12/11/khach-san-vinpearl-hue-17-800x450.jpg", "https://statics.vinpearl.com/gia-phong-vinpearl-hue-2_1627379379.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 3,
      name: "Imperial Hotel Hue",
      address: "08 Hùng Vương",
      hotelLocaton:
      location(latitude: 16.463786394219735, longitude: 107.60703420242594),
      images: ["https://yt3.ggpht.com/ytc/AMLnZu_J1rEF4cTT9WCVqdya_lp1zujGum-jdPtWrUur=s900-c-k-c0x00ffffff-no-rj", "https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/product/2022/03/2ee0927c-e8b1-4a65-86d5-35944611703e.jpg", "https://khamphadisan.com.vn/wp-content/uploads/2016/10/home_imperial.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 3.5),
  hotelModel(
      id: 1,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: ["https://d19lgisewk9l6l.cloudfront.net/assetbank/Exterior_La_Residence_Hotel_Spa_28562.jpg", "https://www.vendomtalents.com/image/news/news-main-azerai-la-residence-opens-in-hue-vietnam.1550593386.jpg", "https://savingbooking.com/wp-content/uploads/2021/01/175012720.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 1,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: ["https://d19lgisewk9l6l.cloudfront.net/assetbank/Exterior_La_Residence_Hotel_Spa_28562.jpg", "https://www.vendomtalents.com/image/news/news-main-azerai-la-residence-opens-in-hue-vietnam.1550593386.jpg", "https://savingbooking.com/wp-content/uploads/2021/01/175012720.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 1,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: ["https://d19lgisewk9l6l.cloudfront.net/assetbank/Exterior_La_Residence_Hotel_Spa_28562.jpg", "https://www.vendomtalents.com/image/news/news-main-azerai-la-residence-opens-in-hue-vietnam.1550593386.jpg", "https://savingbooking.com/wp-content/uploads/2021/01/175012720.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 1,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: ["https://d19lgisewk9l6l.cloudfront.net/assetbank/Exterior_La_Residence_Hotel_Spa_28562.jpg", "https://www.vendomtalents.com/image/news/news-main-azerai-la-residence-opens-in-hue-vietnam.1550593386.jpg", "https://savingbooking.com/wp-content/uploads/2021/01/175012720.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 1,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      hotelLocaton:
      location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: ["https://d19lgisewk9l6l.cloudfront.net/assetbank/Exterior_La_Residence_Hotel_Spa_28562.jpg", "https://www.vendomtalents.com/image/news/news-main-azerai-la-residence-opens-in-hue-vietnam.1550593386.jpg", "https://savingbooking.com/wp-content/uploads/2021/01/175012720.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
];

bool isRecommendationHotel = true;

class _HotHotelsPageState extends State<HotHotelsPage> {
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> distanceCaculating(Position value) async {
    for (int i = 0; i < listHotels.length; i++) {
      listHotels[i].distance = GeolocatorPlatform.instance.distanceBetween(
        value.latitude,
        value.longitude,
        listHotels[i].hotelLocaton.latitude,
        listHotels[i].hotelLocaton.longitude,
      ) /
          1000;
    }
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getUserCurrentLocation().then((value) async {
        print(value.latitude.toString() + " " + value.longitude.toString());
        await distanceCaculating(value);
        setState(() {
          isLoading = false;
        });
      });
    }
    if (isRecommendationHotel) {
      listHotels.sort(
            (b, a) {
          return a.rating!.compareTo(b.rating!);
        },
      );
    } else {
      listHotels.sort(
            (a, b) {
          return a.distance!.compareTo(b.distance!);
        },
      );
    }
    return Scaffold(
        body: Stack(
          children: [
            contentBlock(context),
            backButton(context)
          ],
        ),
    );
  }

  contentBlock(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          banner(context),
          SizedBox(height: 15,),
          descriptionBlock(context),
          SizedBox(height: 15,),
          sortBlock(context),
          SizedBox(height: 15,),
          ...listHotels.map((e) => hotelItem(context, listHotels.indexOf(e)))
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
            color: colors.hotelListViewItem,
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
        height: MediaQuery.of(context).size.height/4,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://cdn4.tropicalsky.co.uk/images/1800x600/indochine-palace-main-image.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter
          )
        ),
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
              Text("Hot Hotels", style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center,),
              Text("Best-rated hotels in the last month", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
  hotelItem(BuildContext context, int index) {
    return ShowRight(
      delay: 300 + index*100,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              // do something
              return HotelDetail(model: listHotels[index]);
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
                      listHotels[index].images.first,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                    EdgeInsets.only(top: 20, right: 20, bottom: 20, left: 10),
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          listHotels[index].name,
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
                                  listHotels[index].rating != null ? listHotels[index].rating! : 0,
                                ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                  text: listHotels[index].rating != null
                                      ? listHotels[index].rating!.toString()
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
                                  text: listHotels[index].distance != null
                                      ? " ${listHotels[index].distance!.toStringAsFixed(2)} km"
                                      : " km",
                                  style: TextStyle(fontSize: 12, color: Colors.black))
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
                                  text: listHotels[index].price.toString(),
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
