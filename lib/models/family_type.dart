class FamilyType {
  late int id;
  late String name;

  FamilyType({this.id = 0, this.name = ""});

  FamilyType.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
  }
}
