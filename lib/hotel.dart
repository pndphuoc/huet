import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hue_t/hotel_detail.dart';
import 'package:hue_t/model/roomTypeModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'colors.dart' as colors;
import 'model/hotelModel.dart';
import 'fade_on_scroll.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/show_up.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}
List<roomTypeModel> roomTypesOfHuongGiangHotel = [roomTypeModel(id: 1, name: "Single room"), roomTypeModel(id: 2, name: "Double room"), roomTypeModel(id: 3, name: "Triple room"), roomTypeModel(id: 4, name: "VIP room")];
List<String> imagesOfHuongGiangHotel = ['https://www.huonggianghotel.com.vn/wp-content/uploads/2018/08/DSC_1308-HDR-Custom-1.jpg', 'https://www.huonggianghotel.com.vn/wp-content/uploads/2018/06/DSC_4563-HDR2_1600x1068-1.jpg', 'https://cf.bstatic.com/xdata/images/hotel/max1280x900/185016305.jpg?k=e0510db64b6c0f4b0623cb63a4014b95c677970d880c414c864fbbe094a9211c&o=&hp=1'];
List<hotelModel> listHotels = [hotelModel(id: 1, name: "Hương Giang", address: "69 Lê Lợi", images: imagesOfHuongGiangHotel, price: 200, types: roomTypesOfHuongGiangHotel, rating: 4.5),
  hotelModel(id: 2, name: "Hương Giang", address: "69 Lê Lợi", images: imagesOfHuongGiangHotel, price: 200, types: roomTypesOfHuongGiangHotel),
  hotelModel(id: 3, name: "Hương Giang", address: "69 Lê Lợi", images: imagesOfHuongGiangHotel, price: 200, types: roomTypesOfHuongGiangHotel),
  hotelModel(id: 1, name: "Hương Giang", address: "69 Lê Lợi", images: imagesOfHuongGiangHotel, price: 200, types: roomTypesOfHuongGiangHotel),
  hotelModel(id: 1, name: "Hương Giang", address: "69 Lê Lợi", images: imagesOfHuongGiangHotel, price: 200, types: roomTypesOfHuongGiangHotel)];

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
final ScrollController scrollController = ScrollController();

class _HotelPageState extends State<HotelPage> {
  final ScrollController scrollController = ScrollController();
  String selectedCheckInDate = '';
  String selectedCheckOutDate = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: banner(),
                    background: Container(
                      color: colors.backgroundColor,
                    ),
                  ),

                  elevation: 0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 170,
                  floating: false,
                  backgroundColor: colors.backgroundColor,
                )
              ];
            },
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: searchBlock(context),
                ),
                Expanded( child: ListView.builder(
                  itemCount: listHotels.length,
                  itemBuilder: (BuildContext context, int index){
                    return hotelItem(context, listHotels[index]);
                  },
                ),)
              ],
            ),
          ),
        ),

      ),
    );
  }
  banner(){
    return ShowUp(
      delay: 0,
      child: Container(
        child: RichText(textAlign: TextAlign.center, text: TextSpan(children: [
          TextSpan(text: "Find the\n", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black, fontSize: 25))),
          TextSpan(text: "PERFECT", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.lightBlue, fontSize: 25, fontWeight: FontWeight.bold))),
          TextSpan(text: " hotel\n", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black, fontSize: 25))),
          TextSpan(text: "for your ", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black, fontSize: 25))),
          TextSpan(text: "TRIP ", style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.lightBlue, fontSize: 25, fontWeight: FontWeight.bold))),
          WidgetSpan(child: Icon(Icons.directions_bike_outlined, size: 20, color: Colors.black,))
        ])),
      ),
    );
  }
  searchBlock(BuildContext context) {
    return ShowUp(
      delay: 250,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Name of hotel/homestay',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
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
                      height: 60,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: ElevatedButton(
                          onPressed: () => _selectCheckInDate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.filterItemColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                            elevation: 0.0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text( selectedCheckInDate!=''?selectedCheckInDate:"Check-In",
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 60,
                    margin: EdgeInsets.only(right: 15, top: 15),
                    child: ElevatedButton(
                        onPressed: () => _selectCheckOutDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.filterItemColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          selectedCheckOutDate!=''?selectedCheckOutDate:"Check-Out",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                child: Center(
                  child: Text(
                    "Find",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: colors.findButtonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            )
          ],
        ),
      ),
    );
  }
  _selectCheckInDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog( initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2025),);
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    setState(() {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectedCheckInDate = formatter.format(selectedDate);
    });
  }
  _selectCheckOutDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog( initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2025),);
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    setState(() {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectedCheckOutDate = formatter.format(selectedDate);
    });
  }
  hotelItem(BuildContext context, hotelModel model) {
    return ShowUp(
      delay: 500,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) {
              // do something
              return HotelDetail(model: model);
            }));
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(model.images.first, fit: BoxFit.cover, height: 100, width: 100,),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20, bottom: 20, left: 10),
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(model.name, style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 1,),
                        RichText(text: TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.pin_drop_outlined, size: 16, color: Colors.grey,)),
                            TextSpan(
                              text: " ${model.address}", style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12)
                            )
                          ]
                        ),),
                        RichText(text: TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.map_outlined, size: 16, color: Colors.grey,)),
                            TextSpan(text: " 0.2 km", style: TextStyle(fontSize: 12, color: Colors.black))
                          ]
                        )),
                        RichText(text: TextSpan(
                          children: [
                            WidgetSpan(child: Icon(Icons.attach_money, size: 20, color: Colors.black,)),
                            TextSpan(text: model.price.toString(), style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,)),
                            TextSpan(text: "/night", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey))
                          ]
                        ))
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
