class Block {
  late int id;
  late String name;
  late String managerId;
  late List families;

  Block.fromJson(Map<String, dynamic> json) {
  id=json["id"]?? 0;
  name=json["name"]??"";
  managerId=json["manager"]??"";
  families=json["families"]??[];
  }
}
