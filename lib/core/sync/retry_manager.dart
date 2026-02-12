import 'dart:async';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../database/database_service.dart';
import 'sync_models.dart';

class RetryManager {
  static RetryManager? _instance;
  static RetryManager get instance => _instance ??= RetryManager._();
  RetryManager._();

  static const int _maxRetries = 5;
  static const List<int> _backoffSeconds = [1, 2, 4, 8, 16];

  /// Schedule an operation for retry with exponential backoff
  Future<void> scheduleRetry(SyncOperation operation) async {
    if (operation.retryCount >= _maxRetries) {
      await _markAsFailed(operation);
      return;
    }

    final db = await DatabaseService.instance.database;
    final backoffDelay =
        _backoffSeconds[operation.retryCount < _backoffSeconds.length
            ? operation.retryCount
            : _backoffSeconds.length - 1];

    final nextRetry = DateTime.now().add(Duration(seconds: backoffDelay));

    await db.update(
      'sync_operations',
      {
        'retry_count': operation.retryCount + 1,
        'next_retry_at': nextRetry.toIso8601String(),
        'last_attempt_at': DateTime.now().toIso8601String(),
        'status': 'pending_retry',
      },
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }

  /// Get operations ready for retry
  Future<List<SyncOperation>> getRetryableOperations() async {
    final db = await DatabaseService.instance.database;
    final now = DateTime.now().toIso8601String();

    final results = await db.query(
      'sync_operations',
      where:
          "status = 'pending_retry' AND next_retry_at <= ? AND retry_count < ?",
      whereArgs: [now, _maxRetries],
      orderBy: 'priority ASC, next_retry_at ASC',
      limit: 50,
    );

    return results.map((map) => SyncOperation.fromMap(map)).toList();
  }

  /// Mark operation as permanently failed after max retries
  Future<void> _markAsFailed(SyncOperation operation) async {
    final db = await DatabaseService.instance.database;

    await db.update(
      'sync_operations',
      {'status': 'failed', 'last_attempt_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }

  /// Reset retry count for an operation
  Future<void> resetRetryCount(String operationId) async {
    final db = await DatabaseService.instance.database;

    await db.update(
      'sync_operations',
      {'retry_count': 0, 'next_retry_at': null, 'status': 'pending'},
      where: 'id = ?',
      whereArgs: [operationId],
    );
  }
}
