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

  // Database-specific fields for sync
  String? syncStatus;
  int? serverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

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
    this.syncStatus,
    this.serverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Family.initial()
    : id = 0,
      name = '',
      location = '',
      familyCatgoryId = 0,
      familyNotes = '',
      blockId = 0,
      familyHeadId = 0,
      familyCategoryName = null,
      familyHeadName = null,
      familyHeadPhoneNumber = null;

  /// Create Family from API JSON response
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

  /// Create Family from database map
  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'],
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      familyCatgoryId: map['family_category_id'] ?? 0,
      familyNotes: map['family_notes'] ?? '',
      blockId: map['block_id'] ?? 0,
      familyHeadId: map['family_head_id'] ?? 0,
      familyCategoryName: null, // Will be joined separately if needed
      familyHeadName: null, // Will be joined separately if needed
      familyHeadPhoneNumber: null,
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

  /// Convert Family to database map
  Map<String, dynamic> toMap() {
    final now = DateTime.now().toIso8601String();
    return {
      if (id != 0) 'id': id,
      'name': name,
      'location': location,
      'family_category_id': familyCatgoryId,
      'family_notes': familyNotes,
      'block_id': blockId,
      'family_head_id': familyHeadId,
      'sync_status': syncStatus ?? 'pending',
      'server_id': serverId,
      'created_at': createdAt?.toIso8601String() ?? now,
      'updated_at': updatedAt?.toIso8601String() ?? now,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Convert to API JSON format for server upload
  Map<String, dynamic> toJson(int? personId) {
    return {
      if (serverId != null) 'id': serverId, // Use server ID for updates
      "name": name,
      "location": location,
      "familyCatgoryId": familyCatgoryId,
      "familyNotes": familyNotes,
      "blockId": blockId,
      "personId": personId ?? familyHeadId,
    };
  }

  /// Copy with method
  Family copyWith({
    int? id,
    String? name,
    String? location,
    int? familyCatgoryId,
    String? familyNotes,
    int? blockId,
    int? familyHeadId,
    String? familyCategoryName,
    String? familyHeadName,
    String? familyHeadPhoneNumber,
    String? syncStatus,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Family(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      familyCatgoryId: familyCatgoryId ?? this.familyCatgoryId,
      familyNotes: familyNotes ?? this.familyNotes,
      blockId: blockId ?? this.blockId,
      familyHeadId: familyHeadId ?? this.familyHeadId,
      familyCategoryName: familyCategoryName ?? this.familyCategoryName,
      familyHeadName: familyHeadName ?? this.familyHeadName,
      familyHeadPhoneNumber:
          familyHeadPhoneNumber ?? this.familyHeadPhoneNumber,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
