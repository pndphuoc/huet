import 'package:flutter/material.dart';
import 'colors.dart' as colors;

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(children: [
                    Image(image: AssetImage("assets/images/hotel/img.png")),
                    IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: MediaQuery.of(context).size.height / 15),
                        child: Column(
                          children: [
                            Text(
                              "Find the perfect hotel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 15),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Name of hotel/home stay',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          filled: true,
                                          fillColor: colors.filterItemColor),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 15, top: 15),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  hintText: 'Check-In',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      15)),
                                                      borderSide:
                                                          BorderSide.none),
                                                  filled: true,
                                                  fillColor:
                                                      colors.filterItemColor),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: 15, top: 15),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  hintText: 'Check-Out',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                      borderSide:
                                                          BorderSide.none),
                                                  filled: true,
                                                  fillColor:
                                                      colors.filterItemColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                    height: 60,
                                    child: ElevatedButton(onPressed: (){},
                                      child: Center(
                                        child: Text("Find", style: TextStyle(
                                          fontSize: 20
                                        ),),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.findButtonColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
