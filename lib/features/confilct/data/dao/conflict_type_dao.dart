import '../../database/dao/base_dao.dart';
import '../../database/database_service.dart';
import '../data/models/conflict_type.dart';

/// Data Access Object for ConflictType
/// Handles database operations for conflict types (lookup/reference data)
class ConflictTypeDao extends BaseDao<ConflictType> {
  final DatabaseService _databaseService;

  ConflictTypeDao(this._databaseService);

  @override
  String get tableName => 'conflict_types';

  @override
  ConflictType fromMap(Map<String, dynamic> map) {
    return ConflictType.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(ConflictType item) {
    return item.toMap();
  }

  @override
  Future<Database> get database async => _databaseService.database;

  /// Get all conflict types (for dropdowns/pickers)
  Future<List<ConflictType>> getAllActive() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NULL',
      orderBy: 'name ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Search conflict types by name
  Future<List<ConflictType>> searchByName(String query) async {
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
