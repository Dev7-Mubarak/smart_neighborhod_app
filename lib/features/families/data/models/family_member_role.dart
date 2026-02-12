class Role {
  final int id;
  final String roleName;
  String? syncStatus;
  int? serverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Role({
    required this.id,
    required this.roleName,
    this.syncStatus,
    this.serverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Create Role from API JSON response
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(id: json['id'], roleName: json['roleName']);
  }

  /// Create Role from database map
  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'],
      roleName: map['role_name'],
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

  /// Convert Role to database map
  Map<String, dynamic> toMap() {
    final now = DateTime.now().toIso8601String();
    return {
      if (id != 0) 'id': id,
      'role_name': roleName,
      'sync_status': syncStatus ?? 'pending',
      'server_id': serverId,
      'created_at': createdAt?.toIso8601String() ?? now,
      'updated_at': updatedAt?.toIso8601String() ?? now,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Copy with method
  Role copyWith({
    int? id,
    String? roleName,
    String? syncStatus,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Role(
      id: id ?? this.id,
      roleName: roleName ?? this.roleName,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
