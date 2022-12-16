class Event {
  String? id;
  String? name;
  String? address;
  String? image;
  List? images;
  String? description;
  String? begin;
  String? end;
  double? price;
  String? organizationName;
  String? note;

  Event(
      {this.id,
      this.name,
      this.address,
      this.image,
      this.images,
      this.description,
      this.begin,
      this.end,
      this.price,
      this.organizationName,
      this.note});

  factory Event.fromJson(Map<String, dynamic> obj) {
    return Event(
        id: obj['id'],
        name: obj['name'],
        address: obj['address'],
        image: obj['image'],
        images: obj['images'],
        description: obj['description'],
        begin: obj['begin'],
        end: obj['end'],
        price: obj['price'],
        organizationName: obj['organizationName'],
        note: obj['note']);
  }
}
