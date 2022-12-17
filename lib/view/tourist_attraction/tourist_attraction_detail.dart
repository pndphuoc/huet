import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/model/attraction/tourist_attraction.dart';

String formatHtmlString(String string) {
  var unescape =  HtmlUnescape();
  var text = unescape.convert(string);
  return text;
}
// ignore: must_be_immutable
class TouristAttractionDetail extends StatefulWidget {
  TouristAttraction item;
  TouristAttractionDetail({super.key, required this.item});

  @override
  State<TouristAttractionDetail> createState() =>
      _TouristAttractionDetailState();
}

class _TouristAttractionDetailState extends State<TouristAttractionDetail> {
  bool visible = false;

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

  Widget header(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: Image.network(
          "https://khamphahue.com.vn/${widget.item.image}",
          fit: BoxFit.cover,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                    child: Icon(Icons.arrow_back_ios_new_outlined)),
              ),
            ),
            const Icon(
              Icons.favorite_border_outlined,
              size: 35,
              color: Colors.black87,
            )
          ],
        ),
      ),
      Positioned(
          bottom: 120,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.4,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...[1, 2, 3, 4].map((e) => Container(
                            padding: const EdgeInsets.all(5),
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://baothuathienhue.vn/image/fckeditor/upload/2019/20191219/images/yeu%20hue%203.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ))
    ]);
  }

  Widget body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 300),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: GoogleFonts.readexPro(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(widget.item.address,
                          maxLines: 2,
                          style: GoogleFonts.readexPro(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 109, 109, 109))),
                    )
                  ],
                ),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(2, 3),
                              color: Colors.grey.withOpacity(0.6))
                        ]),
                    child: Transform.rotate(
                      angle: 45,
                      child: const Icon(
                        Icons.navigation_outlined,
                        color: Color.fromARGB(255, 104, 104, 172),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(0.3)))),
            ),
            descripton(context),
            map(context)
          ],
        ),
      ),
    );
  }

  Widget descripton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final Size sizeFull = (TextPainter(
      text: TextSpan(
        text: widget.item.description.toString().replaceAll('\n', ''),
        style: GoogleFonts.readexPro(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87.withOpacity(0.6)),
      ),
      textScaleFactor: mediaQuery.textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;

    final numberOfLinebreaks =
        widget.item.description.toString().split('\n').length;

    final numberOfLines =
        (sizeFull.width / (mediaQuery.size.width)).ceil() + numberOfLinebreaks;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: GoogleFonts.readexPro(
                fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width,
                height: visible ? sizeFull.height * numberOfLines : 150,
                child: Text(
                  widget.item.description.toString(),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87.withOpacity(0.6)),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                  child: Text(visible ? 'Thu nhỏ' : 'Xem thêm',
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 104, 104, 172))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget map(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Map",
            style: GoogleFonts.readexPro(
                fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.network(
              'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg')
        ],
      ),
    );
  }
}
