class Block {
  late int id;
  late String name;
  late String manger;
  late String image;
  Block.fromJson(Map<String, dynamic> json) {
  id=json["id"];
  name=json["name"];
  manger=json["manager"];
  image=json["image"];
  }
}
