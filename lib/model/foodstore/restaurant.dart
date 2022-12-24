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
  String? id;
  String? title;
  String? image;
  List? category;
  double? rating;
  int? checkin;
  String? address;
  bool? isopen;
  List? description;
  List? menu;
  String? open;
  String? close;
  int? mincost;
  int? maxcost;
  double latitude;
  double longitude;
  double? distance;
  Restaurant(
      {this.id,
      this.title,
      this.image,
      this.category,
      this.rating,
      this.checkin,
      this.address,
      this.isopen,
      this.description,
      this.menu,
      this.open,
      this.close,
      this.mincost,
      this.maxcost,
      required this.latitude,
      required this.longitude});

  factory Restaurant.fromJson(Map<String, dynamic> obj) {
    return Restaurant(
        id: obj['id'],
        title: obj['name'],
        image: obj['image'],
        category: obj['categories'],
        rating: double.parse(obj['rating'].toString()),
        checkin: obj['ratingCount'],
        address: obj['address'],
        isopen: obj['isOpen'],
        description: obj['description'],
        menu: obj['menu'],
        open: obj['openTime'],
        close: obj['closeTime'],
        mincost: obj['minCost'] as int,
        maxcost: obj['maxCost'] as int,
        latitude: obj['latitude'],
        longitude: obj['longitude']);
  }
}

// List<Restaurant> listrestaurant = [
//   Restaurant(
//       id: '1',
//       title: "Tòa Khâm Cafe & Restaurant",
//       image: "assets/images/foodstore/restaurant/4.jpg",
//       category: ["cafe", "restaurant", "Sang Trong"],
//       rating: 4.5,
//       checkin: 400,
//       address: "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
//       isopen: true,
//       description: [
//         "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi."
//       ],
//       menu: [Menu(name: "Coffee SaiGon", image: "")],
//       open: "7:00",
//       close: "21:00",
//       mincost: 10000,
//       maxcost: 35000),
//   Restaurant(
//       id: '2',
//       title: "Cơm Hến Đập Đá",
//       image: "assets/images/foodstore/restaurant/2.jpg",
//       category: ["cafe", "restaurant", "Sang Trong"],
//       rating: 4.1,
//       checkin: 300,
//       address: "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
//       isopen: true,
//       description: [
//         "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi."
//       ],
//       menu: [Menu(name: "Coffee SaiGon", image: "")],
//       open: "7:00",
//       close: "21:00",
//       mincost: 10000,
//       maxcost: 35000),
//   Restaurant(
//       id: '3',
//       title: "Cafe Imperial Hotel",
//       image: "assets/images/foodstore/restaurant/8.jpg",
//       category: ["cafe", "restaurant", "Sang Trong"],
//       rating: 4.7,
//       checkin: 1000,
//       address: "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
//       isopen: true,
//       description: [
//         "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi."
//       ],
//       menu: [Menu(name: "Coffee SaiGon", image: "")],
//       open: "7:00",
//       close: "21:00",
//       mincost: 10000,
//       maxcost: 35000),
//   Restaurant(
//       id: '4',
//       title: "Banh Canh Cua Rời Hương",
//       image: "assets/images/foodstore/restaurant/1.jpg",
//       category: ["cafe", "restaurant", "Sang Trong"],
//       rating: 4.5,
//       checkin: 400,
//       address: "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
//       isopen: true,
//       description: [
//         "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi."
//       ],
//       menu: [Menu(name: "Coffee SaiGon", image: "")],
//       open: "7:00",
//       close: "21:00",
//       mincost: 10000,
//       maxcost: 35000),
//   Restaurant(
//       id: '4',
//       title: "Cafe - Moonlight Hotel",
//       image: "assets/images/foodstore/restaurant/9.jpg",
//       category: ["cafe", "restaurant", "Sang Trong"],
//       rating: 4.5,
//       checkin: 400,
//       address: "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
//       isopen: true,
//       description: [
//         "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi."
//       ],
//       menu: [Menu(name: "Coffee SaiGon", image: "")],
//       open: "7:00",
//       close: "21:00",
//       mincost: 10000,
//       maxcost: 35000),
//   Restaurant(
//       id: '4',
//       title: "Bún bò Huế O Phượng",
//       image: "assets/images/foodstore/restaurant/6.jpg",
//       category: ["cafe", "restaurant", "Sang Trong"],
//       rating: 4.5,
//       checkin: 400,
//       address: "So 30, Tran Truc Nhan, Phuong Vinh Ninh, TP.Hue",
//       isopen: true,
//       description: [
//         "Bún bò Huế là đặc sản nổi tiếng không chỉ trong nước mà bạn bè trên thế giới còn biết đến. Một tô bún bò mang đến nhiều hương vị khác nhau đến từ các gia vị, rau nêm như mùi sả, mùi nước hầm xương, mùi chanh, tiêu,... nhưng vô cùng hòa quyện tạo nên nước dùng đầy đủ hương vị khiến thực khách ăn mãi không thôi."
//       ],
//       menu: [Menu(name: "Coffee SaiGon", image: "")],
//       open: "7:00",
//       close: "21:00",
//       mincost: 10000,
//       maxcost: 35000)
// ];

// List<Restaurant> listrestaurant2 = listrestaurant.map((e) => e).toList();

// sort() {
//   listrestaurant2.sort((b, a) {
//     return a.rating!.compareTo(b.rating!);
//   });
// }
