class FamilyCategory {
  late int id;
  late String name;
  String? syncStatus;
  int? serverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  FamilyCategory({
    this.id = 0,
    this.name = "",
    this.syncStatus,
    this.serverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Create FamilyCategory from API JSON response
  FamilyCategory.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
  }

  /// Create FamilyCategory from database map
  factory FamilyCategory.fromMap(Map<String, dynamic> map) {
    return FamilyCategory(
      id: map['id'],
      name: map['name'],
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

  /// Convert FamilyCategory to database map
  Map<String, dynamic> toMap() {
    final now = DateTime.now().toIso8601String();
    return {
      if (id != 0) 'id': id,
      'name': name,
      'sync_status': syncStatus ?? 'pending',
      'server_id': serverId,
      'created_at': createdAt?.toIso8601String() ?? now,
      'updated_at': updatedAt?.toIso8601String() ?? now,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Copy with method
  FamilyCategory copyWith({
    int? id,
    String? name,
    String? syncStatus,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return FamilyCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
