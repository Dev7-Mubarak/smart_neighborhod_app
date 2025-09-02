class Block {
  late int id;
  late String name;
  late int personId;
  late String email;
  late String fullName;

  Block.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
    personId = json["personId"] ?? "";
    email = json["email"] ?? "";
    fullName = json["fullName"] ?? "";
  }
}
