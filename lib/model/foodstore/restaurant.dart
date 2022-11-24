import 'package:device_preview/device_preview.dart';

//name
//rating
//isopen
//description
//menu
class Menu {
  String? name;
  String? image;
  Menu({this.name, this.image});
}

class Restaurant {
  int? id;
  String? title;
  List<String>? image;
  List<String>? category;
  double? rating;
  int? checkin;
  bool? isopen;
  String? description;
  List<Menu>? menu;

  Restaurant(
      {this.id,
      this.title,
      this.image,
      this.category,
      this.rating,
      this.checkin,
      this.isopen,
      this.description,
      this.menu});
}

List<Restaurant> listrestaurant = [
  Restaurant(
      id: 1,
      title: "Tòa Khâm Cafe & Restaurant",
      image: ["assets/images/foodstore/restaurant/4.jpg"],
      category: ["cafe", "restaurant", "Sang Trong"],
      rating: 4.5,
      checkin: 400,
      isopen: true,
      description: "Bang yeu Quang nhieu lam hehehehehe",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 2,
      title: "Cơm Hến Đập Đá",
      image: ["assets/images/foodstore/restaurant/2.jpg"],
      category: ["cafe", "restaurant", "Sang Trong"],
      rating: 4.1,
      checkin: 300,
      isopen: true,
      description: "A Ca Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 3,
      title: "Cafe Imperial Hotel",
      image: ["assets/images/foodstore/restaurant/8.jpg"],
      category: ["cafe", "restaurant", "Sang Trong"],
      rating: 4.7,
      checkin: 1000,
      isopen: true,
      description: "Lotte Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 4,
      title: "Banh Canh Cua Rời Hương",
      image: ["assets/images/foodstore/restaurant/1.jpg"],
      category: ["cafe", "restaurant", "Sang Trong"],
      rating: 4.5,
      checkin: 400,
      isopen: true,
      description: "King BBQ Buffet Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 4,
      title: "Cafe - Moonlight Hotel",
      image: ["assets/images/foodstore/restaurant/9.jpg"],
      category: ["cafe", "restaurant", "Sang Trong"],
      rating: 4.5,
      checkin: 400,
      isopen: true,
      description: "King BBQ Buffet Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 4,
      title: "Bún bò Huế O Phượng",
      image: ["assets/images/foodstore/restaurant/6.jpg"],
      category: ["cafe", "restaurant", "Sang Trong"],
      rating: 4.5,
      checkin: 400,
      isopen: true,
      description: "King BBQ Buffet Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")])
];

List<Restaurant> listrestaurant2 = listrestaurant.map((e) => e).toList();

sort() {
  listrestaurant2.sort((b, a) {
    return a.rating!.compareTo(b.rating!);
  });
}
