import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/model/foodstore/restaurant.dart';
import 'package:hue_t/view/foodstore/foodstore.dart';
import 'package:hue_t/colors.dart' as color;

class FoodstoreDetail extends StatefulWidget {
  // final Restaurant item;
  const FoodstoreDetail({Key? key}) : super(key: key);

  @override
  State<FoodstoreDetail> createState() => _FoodstoreDetailState();
}

class _FoodstoreDetailState extends State<FoodstoreDetail> {
  var link = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: color.backgroundColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [header(context), body(context)],
          ),
        ),
      ),
    );
  }

  header(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            "assets/images/foodstore/restaurant/6.jpg",
            width: double.infinity,
            height: 230,
            fit: BoxFit.cover,
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: 20,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Foodstore()));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 215, 215)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                            child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 17,
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 215, 215)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                            child: Icon(
                          Icons.favorite_border_outlined,
                          size: 20,
                        )),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  body(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color.backgroundColor),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bang Yeu Quang Nhieu Lam",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 104, 104, 172))),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Text(
                              "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 109, 109, 109))),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: Offset(2, 3),
                                    color: Colors.grey.withOpacity(0.6))
                              ]),
                          child: Transform.rotate(
                            angle: 45,
                            child: Icon(
                              Icons.navigation_outlined,
                              color: Color.fromARGB(255, 104, 104, 172),
                            ),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("4.5",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 109, 109, 109))),
                    SizedBox(
                      width: 7,
                    ),
                    Text("-  1200 Checkin",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 109, 109, 109))),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("07:00 - 21:00",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 96, 97, 96))),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("10.000 - 35.000 VND",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 96, 97, 96)))
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 0.2,
                            color: Color.fromARGB(181, 117, 117, 172)))),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          link = 1;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Text("Introduce",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: link == 1
                                      ? Color.fromARGB(255, 104, 104, 172)
                                      : Color.fromARGB(255, 84, 84, 85))),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          link = 2;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Text("Menu",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: link == 2
                                      ? Color.fromARGB(255, 104, 104, 172)
                                      : Color.fromARGB(255, 84, 84, 85))),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          link = 3;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Text("Map",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: link == 3
                                      ? Color.fromARGB(255, 104, 104, 172)
                                      : Color.fromARGB(255, 84, 84, 85))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AnimatedPositioned(
                  bottom: 0,
                  left: link == 1
                      ? 0
                      : link == 2
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width * 2 / 3,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 104, 104, 172)))),
                  ),
                  duration: Duration(milliseconds: 300))
            ],
          ),
          link == 1
              ? introduce(context)
              : link == 2
                  ? menu(context)
                  : map(context)
        ],
      ),
    );
  }

  introduce(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi.",
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 109, 109, 109)),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          review(context),
        ],
      ),
    );
  }

  menu(BuildContext context) {
    return Container();
  }

  map(BuildContext context) {
    return Container();
  }

  review(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 35,
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 104, 104, 172)),
            child: Center(
              child: Text("Review",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ),
          )
        ],
      ),
    );
  }
}
