import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as colors;
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import 'package:hue_t/providers/tourist_provider.dart';
import 'package:provider/provider.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../fake_data.dart' as faker;

import 'complete_upload.dart';
import 'package:hue_t/fake_data.dart' as faker;

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
  late List<TouristAttraction> _searchResult = [];
  final _searchTextController = TextEditingController();

  _searchAttraction(String value) {
    final _attractionList = Provider.of<TouristAttractionProvider>(context, listen: false).list;
    _searchResult = _attractionList.where((element) => TiengViet.parse(element.title.toLowerCase()).contains(TiengViet.parse(value.trim().toLowerCase()))).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchResult = Provider.of<TouristAttractionProvider>(context, listen: false).list;
  }

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
        child: Consumer<TouristAttractionProvider>(
          builder: (context, value, child) => Column(
            children: [
              searchInputBlock(context),
              const SizedBox(
                height: 20,
              ),
             for(var e in _searchResult)
               touristAttractionBlock(context, e),
            ],
          ),
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
        controller: _searchTextController,
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
        onChanged: (value) {
          _searchAttraction(value);
        },
      ),
    );
  }
}
