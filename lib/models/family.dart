class Family {
  late int id;
  late String name;
  late String location;
  late int familyCatgoryId;
  late String familyNotes;
  late String housingType;
  late int familyTypeId;
  late int blockId;
  late int familyHeadId;

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
    housingType = json["housingType"] ?? "test";
    familyCatgoryId = json["familyCatgoryId"] ?? "test";
    familyTypeId = json["familyTypeId"] ?? "test";
    location = json["location"] ?? "test";
    familyNotes = json["familyNotes"] ?? "test";
    blockId = json["blockId"] ?? 0;
    familyHeadId = json["personId"] ?? 0;
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
