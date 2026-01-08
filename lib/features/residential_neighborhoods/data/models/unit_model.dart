class Unit {
  late int id;
  late String name;
  late String unitManagerId;
  late String unitManagerName;

  Unit.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    unitManagerId = json["unitManagerId"];
    unitManagerName = json["unitManagerName"];
  }
}
