class ConflictCase {
  final int id;
  final String conflictTypeName;
  final String? managerName;
  final String? firstPartyName;
  final String? secondPartyName;
  final String notes;
  final String imageUrl;
  final DateTime sessionDate;
  final bool isResolved;
  final int firstPartyId;
  final int secondPartyId;
  final int conflictTypeId;
  final String title;

  ConflictCase({
    required this.id,
    required this.conflictTypeName,
    this.managerName,
    this.firstPartyName,
    this.secondPartyName,
    required this.notes,
    required this.imageUrl,
    required this.sessionDate,
    required this.isResolved,
    required this.firstPartyId,
    required this.secondPartyId,
    required this.conflictTypeId,
    required this.title,
  });

  factory ConflictCase.fromJson(Map<String, dynamic> json) {
    return ConflictCase(
      id: json['id'] ?? 0,
      conflictTypeName: json['conflictTypeName'] ?? '',
      managerName: json['managerName'],
      firstPartyName: json['firstPartyName'],
      secondPartyName: json['secondPartyName'],
      notes: json['notes'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      sessionDate: DateTime.parse(json['sessionDate'] ?? DateTime.now().toIso8601String()),
      isResolved: json['isResolved'] ?? false,
      firstPartyId: json['firstPartyId'] ?? 0,
      secondPartyId: json['secondPartyId'] ?? 0,
      conflictTypeId: json['conflictTypeId'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conflictTypeName': conflictTypeName,
      'managerName': managerName,
      'firstPartyName': firstPartyName,
      'secondPartyName': secondPartyName,
      'notes': notes,
      'imageUrl': imageUrl,
      'sessionDate': sessionDate.toIso8601String(),
      'isResolved': isResolved,
      'firstPartyId': firstPartyId,
      'secondPartyId': secondPartyId,
      'conflictTypeId': conflictTypeId,
      'title': title,
    };
  }
}