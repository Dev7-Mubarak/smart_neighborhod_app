class Family {
  late int id;
  late String name;
  late String location;
  late int familyCatgoryId;
  late String familyCategoryName;
  late String familyNotes;
  late int familyTypeId;
  late String familyTypeName;
  late int blockId;
  late int familyHeadId;
  late String familyHeadName;
  late String familyHeadPhoneNumber;

  Family({
    required this.name,
    required this.location,
    required this.familyCatgoryId,
    required this.familyTypeId,
    required this.familyNotes,
    required this.blockId,
    required this.familyHeadId,
  });

  Family.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
    familyCatgoryId = json["familyCatgoryId"];
    familyCategoryName = json["familyCatgoryName"];
    familyTypeId = json["familyTypeId"];
    familyTypeName = json["familyTypeName"];
    location = json["location"] ?? "test";
    familyNotes = json["familyNotes"] ?? "test";
    blockId = json["blockId"];
    familyHeadId = json["familyHeadId"] ?? 0;
    familyHeadName = json["familyHeadName"] ?? 0;
    familyHeadPhoneNumber = json["phoneNumber"];
  }

  // Map<String, dynamic> toJson(int? personId) {
  //   return {
  //     "name": name,
  //     "location": location,
  //     "familyCatgoryId": familyCatgoryId,
  //     "familyNotes": familyNotes,
  //     "familyTypeId": familyTypeId,
  //     "blockId": blockId,
  //     "personId": personId
  //   };
  // }
}
