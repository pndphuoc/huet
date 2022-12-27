import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/colors.dart' as color;
import 'package:hue_t/model/attraction/tourist_attraction.dart' as tourist;
import 'package:hue_t/providers/tourist_provider.dart';
import 'package:hue_t/view/tourist_attraction/filter_tourist_attraction.dart';
import 'package:hue_t/view/tourist_attraction/tourist_attraction_detail.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DataModel {
  final String title;
  final String imageName;
  final double price;

  DataModel(
    this.title,
    this.imageName,
    this.price,
  );
}

class TouristAttraction extends StatefulWidget {
  const TouristAttraction({super.key});

  @override
  State<TouristAttraction> createState() => _TouristAttractionState();
}

class _TouristAttractionState extends State<TouristAttraction> {
  late PageController _pageController;
  final int _currentPage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<TouristAttractionProvider>(context);
    if (productProvider.isloading) {
      (() async {
        await productProvider.getAll();

        setState(() {
          productProvider.isloading = false;
        });
      })();
    }
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: productProvider.isloading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: color.primaryColor, size: 50),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Column(
                    children: [
                      header(context),
                      AspectRatio(
                        aspectRatio: 0.85,
                        child: PageView.builder(
                            itemCount: productProvider.list.length,
                            physics: const ClampingScrollPhysics(),
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              return carouselView(index);
                            }),
                      ),
                      categories(context)
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.4)),
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
                Text(
                  "HUE TOURISTATTRACTION",
                  style: GoogleFonts.readexPro(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                  height: 10,
                )
              ],
            ),
          ),
          TextField(
            onSubmitted: (value) {
              if (value != "") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterTourist(
                              categoryId: 0,
                              searchValue: value,
                            )));
              }
            },
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 240, 237, 237),
                hintText: "Search places to visit ...",
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
                        width: 0.2,
                        color: Color.fromARGB(255, 255, 255, 255)))),
          )
        ],
      ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.038).clamp(-1, 1);
        }
        return Consumer<TouristAttractionProvider>(
          builder: (context, value1, child) => Transform.rotate(
            angle: pi * value,
            child: FadeInUp(from: 50, child: carouselCard(value1.list[index])),
          ),
        );
      },
    );
  }

  Widget carouselCard(tourist.TouristAttraction data) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Hero(
              tag: data.title,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TouristAttractionDetail(
                                item: data,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Colors.black26)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: "https://khamphahue.com.vn/${data.image}",
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 7.0, left: 50, right: 50, bottom: 10),
          child: Text(
            data.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
                color: const Color.fromARGB(221, 44, 44, 44),
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  Widget categories(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            items(
                context,
                "Mausoleum",
                "https://hellovietnam24h.com/wp-content/uploads/2018/04/Khai-Dinh-Tomb-in-Hue.jpg",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGNDR4-SEN15pz2O-SKwgSzoRwkCfTR4E8Q-MgsWhJR4YitGDHLQm7smN10xHiYrPzIyM&usqp=CAU",
                "https://azerai.com/wp-content/uploads/2022/02/AZLRH-Destination-Minh-Mang-Mausoleum-1.jpg",
                1),
            items(
                context,
                "Temples",
                "https://sayhellovietnam.com/wp-content/uploads/2020/03/hue-pagoda.jpg",
                "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/23/9e/e2/pagoda.jpg?w=1200&h=900&s=1",
                "https://previews.agefotostock.com/previewimage/medibigoff/772edb9ede97b6e4987867951744a221/bep-bew1a4253e.jpg",
                2),
            items(
                context,
                "Ecological",
                "https://khamphahue.com.vn/Portals/0/Medias/Nam2022/T9/Khamphahue_Vinh-dep-lang-co-hue_21_9_2022_18_00_15_809_CH.jpg",
                "http://en.hellovietnamtravel.com/uploads/images/userfiles/a_luoi_village__a_brand_new_destination_for_ecological_travel_in_hue_vietnam_3.jpg",
                "https://yeshueeco.vn/wp-content/uploads/2019/10/yeshueeco-du-lich-hue-27.jpg",
                3),
            items(
                context,
                "Museum",
                "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/e1/4c/4c/museum-of-royal-antiquities.jpg?w=500&h=-1&s=1",
                "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/d8/5b/f9/le-ba-dang-art-museum.jpg?w=500&h=400&s=1",
                "https://vnn-imgs-f.vgcloud.vn/2020/01/03/16/hue-museum-of-royal-antiquities-in-pictures-7.jpg",
                4),
            items(
                context,
                "Beautiful Check-in",
                "https://khamphahue.com.vn/Portals/0/Medias/Nam2022/T10/Khamphahue_TourHue24h3_26_10_2022_18_55_37_922_CH.jpg",
                "https://khamphahue.com.vn/Portals/0/Medias/Nam2022/T10/Khamphahue_CheckinHue1_27_10_2022_21_17_01_199_CH.jpg",
                "https://kenh14cdn.com/thumb_w/660/2020/3/7/8933295420928602641930072615195351627333632o-1583552097594107640393.jpg",
                5)
          ],
        ),
      ),
    );
  }

  Widget items(BuildContext context, String title, String image1, String image2,
      String image3, int categoryid) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterTourist(
                      categoryId: categoryid,
                      searchValue: "",
                    )));
      },
      child: BounceInLeft(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
          width: double.infinity,
          height: 175,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    color: Color.fromARGB(66, 216, 214, 214))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.readexPro(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 20,
                    color: Colors.black54,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: image1,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: image2,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          image3,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
