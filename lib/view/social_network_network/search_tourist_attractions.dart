import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import '../../fake_data.dart' as faker;

import 'complete_upload.dart';

typedef void AttractionCallback(TouristAttraction val);

class SearchTouristAttractionPage extends StatefulWidget {
  final AttractionCallback callback;

  const SearchTouristAttractionPage({Key? key, required this.callback})
      : super(key: key);

  @override
  State<SearchTouristAttractionPage> createState() =>
      _SearchTouristAttractionPageState();
}

class _SearchTouristAttractionPageState
    extends State<SearchTouristAttractionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.backgroundColor,
        elevation: 0,
        title: Text(
          "Choose a tourist attraction",
          style: GoogleFonts.readexPro(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            searchInputBlock(context),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < 10 && i < faker.listAttraction.length; i++)
              touristAttractionBlock(context, faker.listAttraction[i]),
          ],
        ),
      ),
    );
  }

  touristAttractionBlock(BuildContext context, TouristAttraction att) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          widget.callback(att);
          Navigator.pop(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              att.title,
              style: GoogleFonts.readexPro(color: Colors.black, fontSize: 20),
            ),
            Text(
              att.address,
              style: GoogleFonts.readexPro(
                fontSize: 15,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  searchInputBlock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: colors.SN_panelBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        autofocus: true,
        decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            border: InputBorder.none,
            hintText: "Search for tourist attractions"),
        onChanged: (value) {},
      ),
    );
  }
}
