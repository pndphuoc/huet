class TouristAttaction {
  int id;
  String title;
  String address;
  String description;
  String htmldescription;
  double latitude;
  double longitude;
  String image;
  String images;

  TouristAttaction(
      {required this.id,
        required this.title,
        required this.address,
        required this.description,
        required this.htmldescription,
        required this.image,
        required this.images,
        required this.latitude,
        required this.longitude});
}