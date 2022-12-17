class TouristAttraction {
  int id;
  String title;
  String address;
  String? description;
  String? htmldescription;
  double latitude;
  double longitude;
  String? image;
  String? images;
  List? category;

  TouristAttraction(
      {required this.id,
      required this.title,
      required this.address,
      this.description,
      this.htmldescription,
      this.image,
      this.images,
      required this.latitude,
      required this.longitude,
      required this.category});
  factory TouristAttraction.fromJson(Map<String, dynamic> obj) {
    return TouristAttraction(
        id: obj['ID'],
        title: obj['TenDiaDiem'],
        address: obj['DiaChi'],
        description: obj['MoTaApp'],
        htmldescription: obj['MoTa'],
        latitude: obj['Lat'],
        longitude: obj['Long'],
        image: obj['AnhDaiDien'],
        images: obj['AnhDinhKem'],
        category: obj['CategoryId']);
  }
}
