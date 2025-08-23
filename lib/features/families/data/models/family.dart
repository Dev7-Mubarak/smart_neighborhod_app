class Family {
  late int id;
  late String name;
  late String location;
  late int familyCatgoryId;
  late String familyNotes;
  late int blockId;
  late int familyHeadId;
  String? familyCategoryName;
  String? familyHeadName;
  String? familyHeadPhoneNumber;

  Family({
    required this.id,
    required this.name,
    required this.location,
    required this.familyCatgoryId,
    required this.familyNotes,
    required this.blockId,
    required this.familyHeadId,
    this.familyCategoryName,
    this.familyHeadName,
    this.familyHeadPhoneNumber,
  });

  Family.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
    familyCatgoryId = json["familyCatgoryId"] ?? 0;
    familyCategoryName = json["familyCatgoryName"] ?? "غير معروف";
    location = json["location"] ?? "test";
    familyNotes = json["familyNotes"] ?? "test";
    blockId = json["blockId"] ?? 0;
    familyHeadId = json["familyHeadId"] ?? 0;
    familyHeadName = json["familyHeadName"] ?? "غير معروف";
    familyHeadPhoneNumber = json["phoneNumber"] ?? "غير معروف";
  }

  Map<String, dynamic> toJson(int? personId) {
    return {
      "name": name,
      "location": location,
      "familyCatgoryId": familyCatgoryId,
      "familyNotes": familyNotes,
      "blockId": blockId,
      "personId": personId,
    };
  }
}
