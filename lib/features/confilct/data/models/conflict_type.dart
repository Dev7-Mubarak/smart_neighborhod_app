class ConflictType {
  late int id;
  late String name;
  String? syncStatus; // 'pending', 'synced', 'conflict', 'failed'
  int? serverId; // Server-side ID for syncing
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ConflictType({
    required this.id,
    required this.name,
    this.syncStatus,
    this.serverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Create ConflictType from API JSON response
  factory ConflictType.fromJson(Map<String, dynamic> json) {
    return ConflictType(id: json["id"], name: json["name"]);
  }

  /// Create ConflictType from database map
  factory ConflictType.fromMap(Map<String, dynamic> map) {
    return ConflictType(
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

  /// Convert ConflictType to database map
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

  /// Copy with method for immutability
  ConflictType copyWith({
    int? id,
    String? name,
    String? syncStatus,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ConflictType(
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
