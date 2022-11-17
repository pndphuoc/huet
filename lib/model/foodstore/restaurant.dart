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
  double? rating;
  int? checkin;
  bool? isopen;
  String? description;
  List<Menu>? menu;

  Restaurant(
      {this.id,
      this.title,
      this.image,
      this.rating,
      this.checkin,
      this.isopen,
      this.description,
      this.menu});
}

List<Restaurant> listrestaurant = [
  Restaurant(
      id: 1,
      title: "Kiot Bang Yeu Quang - Phuoc Tuoi",
      image: ["assets/images/foodstore/restaurant/2.jpg"],
      rating: 4.5,
      checkin: 400,
      isopen: true,
      description: "Bang yeu Quang nhieu lam hehehehehe",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 2,
      title: "Sa Bi Chuong Thanh Pho Hue",
      image: ["assets/images/foodstore/restaurant/1.png"],
      rating: 4.1,
      checkin: 300,
      isopen: true,
      description: "A Ca Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 3,
      title: "Coffee VinCom Tang 89",
      image: ["assets/images/foodstore/restaurant/1.jpg"],
      rating: 4.7,
      checkin: 1000,
      isopen: true,
      description: "Lotte Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")]),
  Restaurant(
      id: 4,
      title: "King BBQ Buffet",
      image: ["assets/images/foodstore/restaurant/3.jpeg"],
      rating: 4.5,
      checkin: 400,
      isopen: true,
      description: "King BBQ Buffet Hue is the best",
      menu: [Menu(name: "Coffee SaiGon", image: "")])
];
