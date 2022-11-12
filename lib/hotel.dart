import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hue_t/model/roomTypeModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'colors.dart' as colors;
import 'model/hotelModel.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}
List<roomTypeModel> roomTypesOfHuongGiangHotel = [roomTypeModel(id: 1, name: "Single"), roomTypeModel(id: 2, name: "Double")];
List<String> imagesOfHuongGiangHotel = ['https://www.huonggianghotel.com.vn/wp-content/uploads/2018/08/DSC_1308-HDR-Custom-1.jpg', 'https://www.huonggianghotel.com.vn/wp-content/uploads/2018/06/DSC_4563-HDR2_1600x1068-1.jpg', 'https://cf.bstatic.com/xdata/images/hotel/max1280x900/185016305.jpg?k=e0510db64b6c0f4b0623cb63a4014b95c677970d880c414c864fbbe094a9211c&o=&hp=1'];
List<hotelModel> listHotels = [hotelModel(id: 1, name: "Hương Giang", address: "69 Lê Lợi", images: imagesOfHuongGiangHotel, price: 200, types: roomTypesOfHuongGiangHotel),
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
  String selectedCheckInDate = '';
  String selectedCheckOutDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colors.backgroundColor,
        child: SafeArea(
            child: Column(
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(children: [
                            Image(
                                image: AssetImage("assets/images/hotel/img.png")),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 40),
                                    ),
                                    searchBlock(context),
                                  ],
                                ),
                              ),
                            )
                          ])),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                ConstrainedBox(constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height/2.05
                ),
                  child: AnimationLimiter(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                colors.backgroundColor,
                                Colors.transparent,
                                Colors.transparent,
                                colors.backgroundColor
                              ],
                              stops: [0, 0.01, 0.9, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstOut,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            controller: scrollController,
                            itemCount: listHotels.length,
                            itemBuilder: (BuildContext context, int index){
                              return AnimationConfiguration.staggeredList(position: index,
                                  duration: const Duration(milliseconds: 1000),
                                  child: SlideAnimation(
                                    child: FadeInAnimation(
                                      child: hotelItem(context, listHotels[index]),
                                    ),
                                  ));
                            },
                          )
                      ),
                    ),
                  ),
                )
              ],
            ),

        ),
      ),
    );
  }

  searchBlock(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Name of hotel/home stay',
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
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ElevatedButton(
        onPressed: (){},
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
                padding: EdgeInsets.only(top: 15, bottom: 15),
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
                      Text(model.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 1,),
                      RichText(text: TextSpan(
                        children: [
                          WidgetSpan(child: Icon(Icons.location_pin, size: 16, color: Colors.black,)),
                          TextSpan(
                            text: model.address, style: TextStyle(color: Colors.grey, fontSize: 12)
                          )
                        ]
                      ),),
                      RichText(text: TextSpan(
                        children: [
                          WidgetSpan(child: Icon(Icons.motorcycle, size: 16, color: Colors.black,)),
                          TextSpan(text: " 0.2 km", style: TextStyle(fontSize: 12, color: Colors.grey))
                        ]
                      )),
                      RichText(text: TextSpan(
                        children: [
                          WidgetSpan(child: Icon(Icons.attach_money_rounded, size: 20, color: Colors.black,)),
                          TextSpan(text: model.price.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: "/night", style: TextStyle(fontSize: 12, color: Colors.grey))
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
    );
  }
}
