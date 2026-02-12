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

  // Database-specific fields for sync
  String? syncStatus; // 'pending', 'synced', 'conflict', 'failed'
  int? serverId; // Server-side ID for syncing
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

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
    this.syncStatus,
    this.serverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Create Conflict from API JSON response
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
      title: json['title'] ?? "",
    );
  }

  /// Create Conflict from database map
  factory Conflict.fromMap(Map<String, dynamic> map) {
    return Conflict(
      id: map['id'],
      title: map['title'] ?? '',
      conflictTypeId: map['conflict_type_id'] ?? 0,
      conflictTypeName: map['conflict_type_name'] ?? '',
      managerName: map['manager_name'] ?? '',
      firstPartyId: map['first_party_id'] ?? 0,
      firstPartyName: map['first_party_name'] ?? '',
      secondPartyId: map['second_party_id'] ?? 0,
      secondPartyName: map['second_party_name'] ?? '',
      notes: map['notes'] ?? '',
      imageUrl: map['image_url'] ?? '',
      sessionDate: map['session_date'] != null
          ? DateTime.parse(map['session_date'])
          : null,
      isResolved: (map['is_resolved'] ?? 0) == 1,
      syncStatus: map['sync_status'],
      serverId: map['server_id'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'])
          : null,
    );
  }

  /// Convert Conflict to database map
  Map<String, dynamic> toMap() {
    final now = DateTime.now().toIso8601String();
    return {
      if (id != 0) 'id': id,
      'title': title,
      'conflict_type_id': conflictTypeId,
      'conflict_type_name': conflictTypeName,
      'manager_name': managerName,
      'first_party_id': firstPartyId,
      'first_party_name': firstPartyName,
      'second_party_id': secondPartyId,
      'second_party_name': secondPartyName,
      'notes': notes,
      'image_url': imageUrl,
      'session_date': sessionDate?.toIso8601String(),
      'is_resolved': isResolved ? 1 : 0,
      'sync_status': syncStatus ?? 'pending',
      'server_id': serverId,
      'created_at': createdAt?.toIso8601String() ?? now,
      'updated_at': updatedAt?.toIso8601String() ?? now,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Convert to API JSON format for server upload
  Map<String, dynamic> toJson() {
    return {
      if (serverId != null) 'id': serverId, // Use server ID for updates
      'title': title,
      'conflictTypeId': conflictTypeId,
      'firstPartyId': firstPartyId,
      'secondPartyId': secondPartyId,
      'notes': notes,
      'imageUrl': imageUrl,
      'sessionDate': sessionDate?.toIso8601String(),
      'isResolved': isResolved,
    };
  }

  /// Copy with method for immutability
  Conflict copyWith({
    int? id,
    String? conflictTypeName,
    String? managerName,
    String? firstPartyName,
    String? secondPartyName,
    String? notes,
    String? title,
    String? imageUrl,
    bool? isResolved,
    DateTime? sessionDate,
    int? firstPartyId,
    int? secondPartyId,
    int? conflictTypeId,
    String? syncStatus,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Conflict(
      id: id ?? this.id,
      conflictTypeName: conflictTypeName ?? this.conflictTypeName,
      managerName: managerName ?? this.managerName,
      firstPartyName: firstPartyName ?? this.firstPartyName,
      secondPartyName: secondPartyName ?? this.secondPartyName,
      notes: notes ?? this.notes,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      isResolved: isResolved ?? this.isResolved,
      sessionDate: sessionDate ?? this.sessionDate,
      firstPartyId: firstPartyId ?? this.firstPartyId,
      secondPartyId: secondPartyId ?? this.secondPartyId,
      conflictTypeId: conflictTypeId ?? this.conflictTypeId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
