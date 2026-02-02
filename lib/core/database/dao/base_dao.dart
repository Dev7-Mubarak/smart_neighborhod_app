import 'package:sqflite_sqlcipher/sqflite_sqlcipher.dart';
import '../database_service.dart';

/// Base DAO class providing common CRUD operations
/// All DAOs inherit from this for consistent data access patterns
abstract class BaseDao<T> {
  final String tableName;
  
  BaseDao(this.tableName);
  
  Future<Database> get _db => DatabaseService.instance.database;
  
  /// Convert model to database map
  Map<String, dynamic> toMap(T item);
  
  /// Convert database map to model
  T fromMap(Map<String, dynamic> map);
  
  /// Generate a unique ID for new records
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           '_${DateTime.now().microsecond}';
  }
  
  /// Insert a new record (offline-first)
  Future<String> insert(T item) async {
    final db = await _db;
    final map = toMap(item);
    
    // Ensure sync status is pending for new records
    map['sync_status'] = 'pending';
    map['created_at'] = DateTime.now().toIso8601String();
    map['updated_at'] = DateTime.now().toIso8601String();
    
    await db.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
    return map['id'];
  }
  
  /// Update an existing record
  Future<int> update(T item) async {
    final db = await _db;
    final map = toMap(item);
    
    // Mark as pending sync after update
    map['sync_status'] = 'pending';
    map['updated_at'] = DateTime.now().toIso8601String();
    
    return await db.update(
      tableName,
      map,
      where: 'id = ?',
      whereArgs: [map['id']],
    );
  }
  
  /// Soft delete a record (mark as deleted, don't remove)
  Future<int> softDelete(String id) async {
    final db = await _db;
    return await db.update(
      tableName,
      {
        'deleted_at': DateTime.now().toIso8601String(),
        'sync_status': 'pending',
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  /// Hard delete a record (use only after sync confirmation)
  Future<int> hardDelete(String id) async {
    final db = await _db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
  
  /// Get a single record by ID
  Future<T?> getById(String id) async {
    final db = await _db;
    final results = await db.query(
      tableName,
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
      limit: 1,
    );
    
    if (results.isEmpty) return null;
    return fromMap(results.first);
  }
  
  /// Get all non-deleted records
  Future<List<T>> getAll() async {
    final db = await _db;
    final results = await db.query(
      tableName,
      where: 'deleted_at IS NULL',
      orderBy: 'created_at DESC',
    );
    
    return results.map((map) => fromMap(map)).toList();
  }
  
  /// Get records pending synchronization
  Future<List<T>> getPendingSync() async {
    final db = await _db;
    final results = await db.query(
      tableName,
      where: "sync_status = 'pending'",
      orderBy: 'updated_at ASC',
    );
    
    return results.map((map) => fromMap(map)).toList();
  }
  
  /// Get records that were soft-deleted and need sync
  Future<List<T>> getDeletedPendingSync() async {
    final db = await _db;
    final results = await db.query(
      tableName,
      where: "sync_status = 'pending' AND deleted_at IS NOT NULL",
    );
    
    return results.map((map) => fromMap(map)).toList();
  }
  
  /// Mark record as synced
  Future<void> markAsSynced(String id, String? serverId) async {
    final db = await _db;
    await db.update(
      tableName,
      {
        'sync_status': 'synced',
        'server_id': serverId,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  /// Batch mark records as synced
  Future<void> batchMarkAsSynced(List<String> ids) async {
    final db = await _db;
    final batch = db.batch();
    
    for (final id in ids) {
      batch.update(
        tableName,
        {'sync_status': 'synced'},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    
    await batch.commit(noResult: true);
  }
  
  /// Count records by sync status
  Future<int> countPendingSync() async {
    final db = await _db;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM $tableName WHERE sync_status = 'pending'",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
  
  /// Search records with custom where clause
  Future<List<T>> search({
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await _db;
    
    String fullWhere = 'deleted_at IS NULL';
    if (where != null) {
      fullWhere += ' AND ($where)';
    }
    
    final results = await db.query(
      tableName,
      where: fullWhere,
      whereArgs: whereArgs,
      orderBy: orderBy ?? 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    
    return results.map((map) => fromMap(map)).toList();
  }
  
  /// Insert or update record from server (during sync download)
  Future<void> upsertFromServer(Map<String, dynamic> serverData) async {
    final db = await _db;
    serverData['sync_status'] = 'synced';
    
    await db.insert(
      tableName,
      serverData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// Batch insert from server
  Future<void> batchUpsertFromServer(List<Map<String, dynamic>> serverDataList) async {
    final db = await _db;
    final batch = db.batch();
    
    for (final data in serverDataList) {
      data['sync_status'] = 'synced';
      batch.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    await batch.commit(noResult: true);
  }
}
