import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:hue_t/model/event/event.dart';

String formatHtmlString(String string) {
  var unescape = new HtmlUnescape();
  var text = unescape.convert(string);
  return text;
}

class EventDetail extends StatefulWidget {
  Event item;
  EventDetail({super.key, required this.item});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: GoogleFonts.readexPro(),
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                children: [header(context), content(context)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  header(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.item.image.toString(),
          width: MediaQuery.of(context).size.width,
          height: 270,
          fit: BoxFit.cover,
        ),
        Positioned(
            top: 20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.withOpacity(0.4)),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.favorite_border_outlined,
                      color: Color.fromARGB(255, 194, 193, 193),
                      size: 25,
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  content(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 220),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.name.toString(),
                    style: GoogleFonts.readexPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(255, 104, 104, 172)),
                  child: Center(
                      child: Text("Free Event",
                          style: GoogleFonts.readexPro(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white))),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.timer_outlined),
                Text(
                  " Begin: ${widget.item.begin}",
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(221, 31, 31, 31)),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(Icons.timer_off_outlined),
                Text(
                  " End: ${widget.item.end}",
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(221, 31, 31, 31)),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  child: Text(
                    widget.item.address.toString(),
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(221, 31, 31, 31)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Description",
              style: GoogleFonts.readexPro(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Html(
              data: formatHtmlString(widget.item.description.toString()),
              style: {
                "body": Style(
                    fontSize: const FontSize(15.0),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'readexPro')
              },
            ),
          ],
        ),
      ),
    );
  }
}
