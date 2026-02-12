import '../../../../database/dao/base_dao.dart';
import '../../../../database/database_service.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Simple model for family_members junction table
class FamilyMemberEntry {
  final int id;
  final int familyId;
  final int personId;
  final int? roleId;
  String? syncStatus;
  int? serverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  FamilyMemberEntry({
    required this.id,
    required this.familyId,
    required this.personId,
    this.roleId,
    this.syncStatus,
    this.serverId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory FamilyMemberEntry.fromMap(Map<String, dynamic> map) {
    return FamilyMemberEntry(
      id: map['id'],
      familyId: map['family_id'],
      personId: map['person_id'],
      roleId: map['role_id'],
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

  Map<String, dynamic> toMap() {
    final now = DateTime.now().toIso8601String();
    return {
      if (id != 0) 'id': id,
      'family_id': familyId,
      'person_id': personId,
      'role_id': roleId,
      'sync_status': syncStatus ?? 'pending',
      'server_id': serverId,
      'created_at': createdAt?.toIso8601String() ?? now,
      'updated_at': updatedAt?.toIso8601String() ?? now,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  FamilyMemberEntry copyWith({
    int? id,
    int? familyId,
    int? personId,
    int? roleId,
    String? syncStatus,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return FamilyMemberEntry(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      personId: personId ?? this.personId,
      roleId: roleId ?? this.roleId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

/// Data Access Object for FamilyMember junction table
/// Handles database operations for family_members table
class FamilyMemberDao extends BaseDao<FamilyMemberEntry> {
  final DatabaseService _databaseService;

  FamilyMemberDao(this._databaseService) : super('family_members');

  @override
  String get tableName => 'family_members';

  @override
  FamilyMemberEntry fromMap(Map<String, dynamic> map) {
    return FamilyMemberEntry.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(FamilyMemberEntry item) {
    return item.toMap();
  }

  @override
  Future<Database> get database async => _databaseService.database;

  /// Get all members of a family
  Future<List<FamilyMemberEntry>> getByFamilyId(int familyId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'family_id = ? AND deleted_at IS NULL',
      whereArgs: [familyId],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get all families a person belongs to
  Future<List<FamilyMemberEntry>> getByPersonId(int personId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'person_id = ? AND deleted_at IS NULL',
      whereArgs: [personId],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get members by role
  Future<List<FamilyMemberEntry>> getByRoleId(int roleId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'role_id = ? AND deleted_at IS NULL',
      whereArgs: [roleId],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Check if person is already a member of family
  Future<bool> isMemberOfFamily(int familyId, int personId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'family_id = ? AND person_id = ? AND deleted_at IS NULL',
      whereArgs: [familyId, personId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Delete family member by family and person
  Future<int> deleteByFamilyAndPerson(int familyId, int personId) async {
    final db = await database;
    return await db.update(
      tableName,
      {
        'deleted_at': DateTime.now().toIso8601String(),
        'sync_status': 'pending',
      },
      where: 'family_id = ? AND person_id = ?',
      whereArgs: [familyId, personId],
    );
  }

  @override
  Future<List<FamilyMemberEntry>> getAll() async {
    final db = await database;
    final maps = await db.query(tableName, where: 'deleted_at IS NULL');
    return maps.map((map) => fromMap(map)).toList();
  }
}
