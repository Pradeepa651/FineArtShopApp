class Item {
  String name;
  int price;
  String? place;
  String? description;
  String? imagePath;
  String docId;

  Item(
      {required this.name,
      required this.price,
      this.description,
      this.imagePath,
      this.place,
      required this.docId});
}
