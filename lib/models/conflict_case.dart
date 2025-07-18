class ConflictCase {
  final int id;
  final String conflictTypeName;
  final String? managerName;
  final String? firstPartyName;
  final String? secondPartyName;
  final String notes;
  final String? imageUrl;
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
    this.imageUrl,
    required this.sessionDate,
    required this.isResolved,
    required this.firstPartyId,
    required this.secondPartyId,
    required this.conflictTypeId,
    required this.title,
  });

  factory ConflictCase.fromJson(Map<String, dynamic> json) {
    return ConflictCase(
      id: json['id'] as int,
      conflictTypeName: json['conflictTypeName'] as String,
      managerName: json['managerName'] as String?,
      firstPartyName: json['firstPartyName'] as String?,
      secondPartyName: json['secondPartyName'] as String?,
      notes: json['notes'] as String,
      imageUrl: json['imageUrl'] as String?,
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      isResolved: json['isResolved'] as bool,
      firstPartyId: json['firstPartyId'] as int,
      secondPartyId: json['secondPartyId'] as int,
      conflictTypeId: json['conflictTypeId'] as int,
      title: json['title'] as String,
    );
  }
}