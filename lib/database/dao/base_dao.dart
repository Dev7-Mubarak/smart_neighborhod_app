import 'package:sqflite_sqlcipher/sqflite.dart';

import '../database_service.dart';

abstract class BaseDao<T> {
  final String tableName;

  BaseDao(this.tableName);

  Future<Database> get _db => DatabaseService.instance.database;

  Map<String, dynamic> toMap(T item);
  T fromMap(Map<String, dynamic> map);

  Future<int> insert(T item) async {
    final db = await _db;
    final map = toMap(item);

    map.remove('id');
    map['sync_status'] = 'pending';

    final now = DateTime.now().toIso8601String();
    map['created_at'] ??= now;
    map['updated_at'] = now;

    final id = await db.insert(
      tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return id;
  }

  Future<int> update(T item) async {
    final db = await _db;
    final map = toMap(item);

    if (map['id'] == null) {
      throw ArgumentError('Cannot update record without an id');
    }

    map['sync_status'] = 'pending';
    map['updated_at'] = DateTime.now().toIso8601String();

    return db.update(tableName, map, where: 'id = ?', whereArgs: [map['id']]);
  }

  Future<int> softDelete(int id) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();

    return db.update(
      tableName,
      {'deleted_at': now, 'updated_at': now, 'sync_status': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> hardDelete(int id) async {
    final db = await _db;
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<T?> getById(int id) async {
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

    return results.map(fromMap).toList();
  }

  /// Records pending upload to server
  Future<List<T>> getPendingSync() async {
    final db = await _db;

    final results = await db.query(
      tableName,
      where: "sync_status = 'pending'",
      orderBy: 'updated_at ASC',
    );

    return results.map(fromMap).toList();
  }

  /// Soft-deleted records pending sync
  Future<List<T>> getDeletedPendingSync() async {
    final db = await _db;

    final results = await db.query(
      tableName,
      where: "sync_status = 'pending' AND deleted_at IS NOT NULL",
    );

    return results.map(fromMap).toList();
  }

  /// Mark a record as synced after successful upload
  Future<void> markAsSynced(int id, {int? serverId}) async {
    final db = await _db;

    await db.update(
      tableName,
      {
        'sync_status': 'synced',
        if (serverId != null) 'server_id': serverId,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Batch mark records as synced
  Future<void> batchMarkAsSynced(List<int> ids) async {
    final db = await _db;

    await db.transaction((txn) async {
      final batch = txn.batch();

      final now = DateTime.now().toIso8601String();

      for (final id in ids) {
        batch.update(
          tableName,
          {'sync_status': 'synced', 'updated_at': now},
          where: 'id = ?',
          whereArgs: [id],
        );
      }

      await batch.commit(noResult: true);
    });
  }

  /// Count records pending sync
  Future<int> countPendingSync() async {
    final db = await _db;

    final result = await db.rawQuery(
      "SELECT COUNT(*) AS count FROM $tableName WHERE sync_status = 'pending'",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Flexible search (always excludes soft-deleted records)
  Future<List<T>> search({
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await _db;

    var fullWhere = 'deleted_at IS NULL';
    if (where != null && where.trim().isNotEmpty) {
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

    return results.map(fromMap).toList();
  }

  /// Upsert data coming FROM server (server is source of truth)
  Future<void> upsertFromServer(Map<String, dynamic> serverData) async {
    final db = await _db;

    serverData['sync_status'] = 'synced';
    serverData['updated_at'] ??= DateTime.now().toIso8601String();

    await db.insert(
      tableName,
      serverData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Batch upsert from server
  Future<void> batchUpsertFromServer(
    List<Map<String, dynamic>> serverDataList,
  ) async {
    final db = await _db;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final data in serverDataList) {
        data['sync_status'] = 'synced';
        data['updated_at'] ??= DateTime.now().toIso8601String();

        batch.insert(
          tableName,
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  /// Find by server_id
  Future<T?> getByServerId(int serverId) async {
    final db = await _db;

    final results = await db.query(
      tableName,
      where: 'server_id = ? AND deleted_at IS NULL',
      whereArgs: [serverId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return fromMap(results.first);
  }
}
