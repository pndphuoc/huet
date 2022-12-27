import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/animation/show_right.dart';
import 'package:hue_t/model/attraction/tourist_attraction.dart';
import 'package:hue_t/providers/tourist_provider.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/view/tourist_attraction/tourist_attraction_detail.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FilterTourist extends StatefulWidget {
  int categoryId;
  String searchValue;

  FilterTourist(
      {super.key, required this.categoryId, required this.searchValue});

  @override
  State<FilterTourist> createState() => _FilterTouristState();
}

class _FilterTouristState extends State<FilterTourist> {
  bool isLoading = true;
  bool isLoading2 = true;
  int popular1 = 1;
  int? value;
  late String valueSearch;
  List<TouristAttraction> listSearch = [];

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<TouristAttractionProvider>(context);

    if (isLoading && value != 0) {
      value = widget.categoryId;
      valueSearch = "";

      (() async {
        await productProvider.filter(widget.categoryId);

        setState(() {
          isLoading = false;
          isLoading2 = false;
        });
      })();
    }
    if (isLoading2 && value != 0) {
      (() async {
        await productProvider.filter(value);

        setState(() {
          isLoading2 = false;
        });
      })();
    }
    if (isLoading2 && value == 0) {
      (() async {
        if (valueSearch == "") {
          valueSearch = widget.searchValue;
        }
        // ignore: await_only_futures
        listSearch = productProvider.search(valueSearch!);
        setState(() {
          isLoading2 = false;
        });
      })();
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                child: Column(
                  children: [
                    search(context),
                    categories(context),
                  ],
                ),
              ),
              isLoading2
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: color.primaryColor, size: 50),
                    )
                  : result(context),
            ],
          ),
        ),
      ),
    );
  }

  search(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 241, 241),
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
            Consumer<TouristAttractionProvider>(
              builder: (context, value2, child) => Expanded(
                child: TextField(
                  onChanged: (value1) {
                    setState(() {
                      isLoading2 = true;
                      value = 0;
                      valueSearch = value1;
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: color.filterItemColor,
                      hintText: "What are you cracing?",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 206, 205, 205)),
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                            width: 0.2,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                              width: 0.2,
                              color: Color.fromARGB(255, 255, 255, 255)))),
                ),
              ),
            ),
          ],
        ));
  }

  result(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Consumer<TouristAttractionProvider>(
        builder: (context, value, child) => Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            valueSearch == ""
                ? resultSearch(context, value.listFilter)
                : resultSearch(context, listSearch)
          ],
        ),
      ),
    );
  }

  categories(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              isLoading2 = true;
              value = 0;
              valueSearch = " ";
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == 0
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'All',
                style: GoogleFonts.readexPro(
                    color: value == 0
                        ? Colors.white
                        : const Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isLoading2 = true;
              value = 1;
              valueSearch = "";
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == 1
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Mausoleum',
                style: GoogleFonts.readexPro(
                    color: value == 1
                        ? Colors.white
                        : const Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isLoading2 = true;
              value = 2;
              valueSearch = "";
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == 2
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Temples',
                style: GoogleFonts.readexPro(
                    color: value == 2
                        ? Colors.white
                        : const Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isLoading2 = true;
              value = 3;
              valueSearch = "";
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == 3
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Ecological',
                style: GoogleFonts.readexPro(
                    color: value == 3
                        ? Colors.white
                        : const Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isLoading2 = true;
              value = 4;
              valueSearch = "";
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == 4
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Museum',
                style: GoogleFonts.readexPro(
                    color: value == 4
                        ? Colors.white
                        : const Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              isLoading2 = true;
              value = 5;
              valueSearch = "";
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: value == 5
                      ? const Color.fromARGB(255, 104, 104, 172)
                      : const Color.fromARGB(255, 231, 230, 230),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Beatiful Check-in',
                style: GoogleFonts.readexPro(
                    color: value == 5
                        ? Colors.white
                        : const Color.fromARGB(255, 75, 75, 75)),
              ),
            ),
          )
        ],
      ),
    );
  }

  resultSearch(BuildContext context, List<TouristAttraction> listlist) {
    return SingleChildScrollView(
      child: Consumer<TouristAttractionProvider>(
        builder: (context, value, child) => Column(
          children: [
            ...listlist.map((e) => ShowRight(
              delay: 100 * listlist.indexOf(e),
              child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TouristAttractionDetail(
                                    item: e,
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                  imageUrl:
                                      "https://khamphahue.com.vn/${e.image}",
                                  height: double.infinity,
                                  width: 90,
                                  fit: BoxFit.cover),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(e.title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.readexPro(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(e.address.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.readexPro(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            ))
          ],
        ),
      ),
    );
  }
}
