import '../../../../database/dao/base_dao.dart';
import '../../../../database/database_service.dart';
import '../models/family_category.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Data Access Object for FamilyCategory
/// Handles database operations for family categories (lookup/reference data)
class FamilyCategoryDao extends BaseDao<FamilyCategory> {
  final DatabaseService _databaseService;

  FamilyCategoryDao(this._databaseService) : super('family_categories');

  @override
  FamilyCategory fromMap(Map<String, dynamic> map) {
    return FamilyCategory.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(FamilyCategory item) {
    return item.toMap();
  }

  @override
  Future<Database> get database async => _databaseService.database;

  /// Get all active family categories (for dropdowns/pickers)
  Future<List<FamilyCategory>> getAllActive() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NULL',
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Search family categories by name
  Future<List<FamilyCategory>> searchByName(String query) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'name LIKE ? AND deleted_at IS NULL',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }
}
