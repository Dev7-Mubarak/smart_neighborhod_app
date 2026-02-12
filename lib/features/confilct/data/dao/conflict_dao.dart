import '../../../../database/dao/base_dao.dart';
import '../../../../database/database_service.dart';
import '../models/conflict.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

/// Data Access Object for Conflict
/// Handles database operations for conflicts table
class ConflictDao extends BaseDao<Conflict> {
  final DatabaseService _databaseService;

  ConflictDao(this._databaseService);

  @override
  String get tableName => 'conflicts';

  @override
  Conflict fromMap(Map<String, dynamic> map) {
    return Conflict.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(Conflict item) {
    return item.toMap();
  }

  @override
  Future<Database> get database async => _databaseService.database;

  /// Get conflicts by resolution status
  Future<List<Conflict>> getByResolutionStatus(bool isResolved) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'is_resolved = ? AND deleted_at IS NULL',
      whereArgs: [isResolved ? 1 : 0],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get conflicts by type
  Future<List<Conflict>> getByTypeId(int conflictTypeId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'conflict_type_id = ? AND deleted_at IS NULL',
      whereArgs: [conflictTypeId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get conflicts involving a specific person (as either party)
  Future<List<Conflict>> getByPersonId(int personId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where:
          '(first_party_id = ? OR second_party_id = ?) AND deleted_at IS NULL',
      whereArgs: [personId, personId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Search conflicts by title, notes, or party names
  Future<List<Conflict>> search(String query) async {
    final db = await database;
    final searchPattern = '%$query%';
    final maps = await db.query(
      tableName,
      where: '''
        (title LIKE ? OR 
         notes LIKE ? OR 
         first_party_name LIKE ? OR 
         second_party_name LIKE ? OR
         manager_name LIKE ?) 
        AND deleted_at IS NULL
      ''',
      whereArgs: [
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
      ],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get conflicts scheduled for a specific date
  Future<List<Conflict>> getBySessionDate(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD
    final maps = await db.query(
      tableName,
      where: "date(session_date) = ? AND deleted_at IS NULL",
      whereArgs: [dateStr],
      orderBy: 'session_date ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Get upcoming conflicts (future session dates)
  Future<List<Conflict>> getUpcoming() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      tableName,
      where: 'session_date > ? AND is_resolved = 0 AND deleted_at IS NULL',
      whereArgs: [now],
      orderBy: 'session_date ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  /// Update conflict resolution status
  Future<int> updateResolutionStatus(int id, bool isResolved) async {
    final db = await database;
    return await db.update(
      tableName,
      {
        'is_resolved': isResolved ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
        'sync_status': 'pending', // Mark for sync
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Conflict>> getAll() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'deleted_at IS NULL',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }
}
