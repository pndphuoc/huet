import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/profileuser/profile_user.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:swipe/swipe.dart';

import '../../model/attraction/tourist_attraction.dart';
import '../../providers/tourist_provider.dart';
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
    Offset? _initialPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            headerFavoritePage(context),
            searchFavorite(context),
            contentFavorite(context),
          ],
        ),
      ),
    );
  }

  headerFavoritePage(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            backButton(context),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My Favorite',
                    style: GoogleFonts.readexPro(
                        fontSize: 25, fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  searchFavorite(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 240, 237, 237),
              hintText: "Search favorite ...",
              hintStyle: TextStyle(color: Color.fromARGB(255, 206, 205, 205)),
              prefixIcon: Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(
                    width: 0.2, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                      width: 0.2, color: Color.fromARGB(255, 255, 255, 255))))),
    );
  }

  backButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))))),
    );
  }

  contentFavorite(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child:
          Row(
            children: [
              Text('Best ',style: GoogleFonts.readexPro(fontWeight: FontWeight.w300, fontSize: 25), ),
              Text('Locations', style: GoogleFonts.readexPro(fontWeight: FontWeight.w200, fontSize: 25),)
            ],
            ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 35,),
              Text('All', style: GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w200),),
              const SizedBox(width: 35,),
              Text('Food', style: GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w200),),
              const SizedBox(width: 35,),
              Text('Location',  style: GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w200),),
              const SizedBox(width: 35,),
              Text('Hotel',  style: GoogleFonts.readexPro(fontSize: 17, fontWeight: FontWeight.w200),)
            ],
          ),
        ),
        returnSearchFavorite(context)
      ],
    );
  }
}

returnSearchFavorite(BuildContext context)
{
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(15),
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
                child: Image.network(
                    "https://xaydung.edu.vn/wp-content/uploads/da-nang-hue.jpg",
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
                    Text('Đại nội kinh thành Huế',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.readexPro(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    Text('Địa chỉ',
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
  );
}

resultSearch(BuildContext context, List<TouristAttraction> listlist) {
  return SingleChildScrollView(
    child: Consumer<TouristAttractionProvider>(
      builder: (context, value, child) => Column(
        children: [
          ...listlist.map((e) => GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => TouristAttractionDetail(
              //           item: e,
              //         )));
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
                      child: Image.network(
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
          ))
        ],
      ),
    ),
  );
}