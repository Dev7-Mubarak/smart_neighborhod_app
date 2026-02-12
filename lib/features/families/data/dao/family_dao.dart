import '../../../../database/dao/base_dao.dart';
import '../../../../database/database_service.dart';
import '../models/family.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Data Access Object for Family
/// Handles database operations for families table
class FamilyDao extends BaseDao<Family> {
  final DatabaseService _databaseService;

  FamilyDao(this._databaseService) : super('families');

  @override
  String get tableName => 'families';

  @override
  Family fromMap(Map<String, dynamic> map) {
    return Family.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(Family item) {
    return item.toMap();
  }

  @override
  Future<Database> get database async => _databaseService.database;

  /// Get families by block ID
  Future<List<Family>> getByBlockId(int blockId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'block_id = ? AND deleted_at IS NULL',
      whereArgs: [blockId],
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get families by category
  Future<List<Family>> getByCategoryId(int categoryId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'family_category_id = ? AND deleted_at IS NULL',
      whereArgs: [categoryId],
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get families by family head (person ID)
  Future<List<Family>> getByFamilyHeadId(int familyHeadId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'family_head_id = ? AND deleted_at IS NULL',
      whereArgs: [familyHeadId],
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Search families by name or location
  Future<List<Family>> searchByText(String query) async {
    final db = await database;
    final searchPattern = '%$query%';
    final maps = await db.query(
      tableName,
      where: '''
        (name LIKE ? OR location LIKE ?) 
        AND deleted_at IS NULL
      ''',
      whereArgs: [searchPattern, searchPattern],
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  @override
  Future<List<Family>> getAll() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NULL',
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }
}
