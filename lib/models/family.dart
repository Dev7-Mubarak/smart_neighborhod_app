class Family {
  final int id;
  final String name;
  final String location;
  final int familyCatgoryId;
  final String? familyCategoryName;
  final String familyNotes;
  final int familyTypeId;
  final String? familyTypeName;
  final int blockId;
  final int familyHeadId;
  final String? familyHeadName;
  final String? familyHeadPhoneNumber;

  Family({
    required this.id,
    required this.name,
    required this.location,
    required this.familyCatgoryId,
    required this.familyTypeId,
    required this.familyNotes,
    required this.blockId,
    required this.familyHeadId,
    this.familyCategoryName,
    this.familyTypeName,
    this.familyHeadName,
    this.familyHeadPhoneNumber,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      location: json["location"] ?? '',
      familyCatgoryId: json["familyCatgoryId"] ?? 0,
      familyCategoryName: json["familyCatgoryName"],
      familyTypeId: json["familyTypeId"] ?? 0,
      familyTypeName: json["familyTypeName"],
      familyNotes: json["familyNotes"] ?? '',
      blockId: json["blockId"] ?? 0,
      familyHeadId: json["familyHeadId"] ?? 0,
      familyHeadName: json["familyHeadName"],
      familyHeadPhoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "location": location,
      "familyCatgoryId": familyCatgoryId,
      "familyTypeId": familyTypeId,
      "familyNotes": familyNotes,
      "blockId": blockId,
      "familyHeadId": familyHeadId,
    };
  }
}
