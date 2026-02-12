import '../../../../database/dao/base_dao.dart';
import '../../../../database/database_service.dart';
import '../models/family_member_role.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Data Access Object for FamilyMemberRole (Role)
/// Handles database operations for family member roles (lookup/reference data)
class FamilyMemberRoleDao extends BaseDao<Role> {
  final DatabaseService _databaseService;

  FamilyMemberRoleDao(this._databaseService) : super('family_member_roles');

  @override
  String get tableName => 'family_member_roles';

  @override
  Role fromMap(Map<String, dynamic> map) {
    return Role.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(Role item) {
    return item.toMap();
  }

  @override
  Future<Database> get database async => _databaseService.database;

  /// Get all active family member roles (for dropdowns/pickers)
  Future<List<Role>> getAllActive() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NULL',
      orderBy: 'role_name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Search family member roles by name
  Future<List<Role>> searchByName(String query) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'role_name LIKE ? AND deleted_at IS NULL',
      whereArgs: ['%$query%'],
      orderBy: 'role_name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }
}
