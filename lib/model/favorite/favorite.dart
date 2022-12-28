class Favorite {
  String id;
  String name;
  String address;
  String image;
  int category;
  String userID;
  Favorite(
      {required this.id,
      required this.name,
      required this.address,
      required this.image,
      required this.category,
      required this.userID});
  factory Favorite.fromJson(Map<String, dynamic> obj) {
    return Favorite(
        id: obj['id'],
        name: obj['name'],
        image: obj['image'],
        address: obj['address'],
        category: obj['category'],
        userID: obj['userID']);
  }
}
