class Conflict {
  late int id;
  late String conflictTypeName;
  late String managerName;
  late String firstPartyName;
  late String secondPartyName;
  late String notes;
  late String title;
  late String imageUrl;
  late bool isResolved;
  late DateTime? sessionDate;
  late int firstPartyId;
  late int secondPartyId;
  late int conflictTypeId;

  Conflict({
    required this.id,
    required this.conflictTypeName,
    required this.firstPartyId,
    required this.firstPartyName,
    required this.imageUrl,
    required this.isResolved,
    required this.conflictTypeId,
    required this.title,
    required this.managerName,
    required this.notes,
    required this.secondPartyId,
    required this.secondPartyName,
    required this.sessionDate,
  });

  factory Conflict.fromJson(Map<String, dynamic> json) {
    return Conflict(
      id: json["id"],
      conflictTypeName: json["conflictTypeName"] ?? "",
      managerName: json["managerName"] ?? "",
      firstPartyName: json["firstPartyName"] ?? "",
      secondPartyName: json['secondPartyName'] ?? "",
      notes: json['notes'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      sessionDate: json['sessionDate'] != null
          ? DateTime.parse(json['sessionDate'])
          : null,
      isResolved: json['isResolved'] ?? false,
      firstPartyId: json["firstPartyId"] ?? 0,
      secondPartyId: json["secondPartyId"] ?? 0,
      conflictTypeId: json["conflictTypeId"] ?? 0, 
      title:json['title'] ?? "",
    );
  }
}
