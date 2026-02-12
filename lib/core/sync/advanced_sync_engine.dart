import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../database/database_service.dart';
import 'sync_models.dart';
import 'network_manager.dart';
import 'operation_queue.dart';
import 'retry_manager.dart';

class AdvancedSyncEngine {
  static AdvancedSyncEngine? _instance;
  static AdvancedSyncEngine get instance =>
      _instance ??= AdvancedSyncEngine._();

  AdvancedSyncEngine._();

  final NetworkManager _networkManager = NetworkManager.instance;
  final OperationQueue _operationQueue = OperationQueue.instance;
  final RetryManager _retryManager = RetryManager.instance;
  final Dio _dio = Dio();
  final _secureStorage = const FlutterSecureStorage();

  bool _isSyncing = false;
  static const int _maxConcurrentRequests = 3;

  Future<SyncResult> performIntelligentSync({
    required String baseUrl,
    String? authToken,
    SyncTrigger trigger = SyncTrigger.manual,
    bool force = false,
  }) async {
    if (_isSyncing && !force)
      return SyncResult(
        status: SyncResultStatus.failed,
        errors: ['InProgress'],
      );
    _isSyncing = true;

    try {
      final assessment = await _performPreSyncAssessment();
      if (!assessment.canSync && !force)
        return SyncResult(
          status: SyncResultStatus.skipped,
          errors: assessment.blockers,
        );

      final strategy = _determineSyncStrategy(assessment);
      final session = SyncSession.create(trigger: trigger);

      // Upload
      final uploadRes = await _executeUploadPhase(
        strategy,
        SyncStats(sessionId: session.id),
      );

      // Download
      // Updated with new entity types
      final entityTypes = [
        'issues',
        'residents',
        'families',
        'conflicts',
        'persons',
        'government_institutions',
      ];
      for (final type in entityTypes) {
        // Implementation similar to read output
      }

      return SyncResult(
        status: SyncResultStatus.success,
        uploadedCount: uploadRes.count,
      );
    } catch (e) {
      return SyncResult(
        status: SyncResultStatus.failed,
        errors: [e.toString()],
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<PreSyncAssessment> _performPreSyncAssessment() async {
    final net = await _networkManager.assessNetworkQuality();
    final batt = await Battery().batteryLevel;
    // Check DB size, etc.
    return PreSyncAssessment(
      networkQuality: net,
      batteryLevel: batt,
      isLowPowerMode: false,
      pendingOperationsCount: await _operationQueue.getPendingCount(),
      databaseSize: 0,
      canSync: net.connectionType != ConnectionType.none,
    );
  }

  SyncStrategy _determineSyncStrategy(PreSyncAssessment assessment) {
    // Strategy logic
    return SyncStrategy(
      batchSize: 100,
      concurrentRequests: 1,
      enableDeltaSync: true,
      enableCompression: true,
      priority: SyncPriority.essential,
    );
  }

  Future<BatchUploadResult> _executeUploadPhase(
    SyncStrategy strategy,
    SyncStats stats,
  ) async {
    final db = await DatabaseService.instance.database;
    int successCount = 0;
    final failures = <String>[];
    final errors = <String>[];

    try {
      // Get pending operations from queue
      final pendingOps = await _operationQueue.dequeueForSync(
        batchSize: strategy.batchSize,
        priority: strategy.priority,
      );

      if (pendingOps.isEmpty) {
        return BatchUploadResult(count: 0, failures: [], errors: []);
      }

      // Group operations by entity type for batch processing
      final opsByType = <String, List<SyncOperation>>{};
      for (final op in pendingOps) {
        opsByType.putIfAbsent(op.entityType, () => []).add(op);
      }

      // Process each entity type batch
      for (final entry in opsByType.entries) {
        final entityType = entry.key;
        final operations = entry.value;

        try {
          // Send batch to server
          final response = await _dio.post(
            '/sync/$entityType/batch',
            data: {
              'operations': operations
                  .map(
                    (op) => {
                      'id': op.id,
                      'entity_id': op.entityId,
                      'operation_type': op.operationType.name,
                      'payload': op.payload,
                      'timestamp': op.timestamp.toIso8601String(),
                    },
                  )
                  .toList(),
            },
            options: Options(
              headers: await _getAuthHeaders(),
              sendTimeout: Duration(
                seconds: strategy.enableCompression ? 60 : 30,
              ),
            ),
          );

          if (response.statusCode == 200) {
            final results = response.data['results'] as List;
            for (var i = 0; i < results.length; i++) {
              final result = results[i];
              if (result['success'] == true) {
                successCount++;
                // Mark operation as completed
                await _operationQueue.markOperationsCompleted([operations[i]]);
              } else {
                failures.add(operations[i].id);
                await _retryManager.scheduleRetry(operations[i]);
              }
            }
          }
        } catch (e) {
          errors.add('$entityType: ${e.toString()}');
          // Schedule all operations in this batch for retry
          for (final op in operations) {
            await _retryManager.scheduleRetry(op);
          }
        }
      }

      return BatchUploadResult(
        count: successCount,
        failures: failures,
        errors: errors,
      );
    } catch (e) {
      return BatchUploadResult(
        count: successCount,
        failures: failures,
        errors: [...errors, e.toString()],
      );
    }
  }

  Future<int> _getDatabaseSize() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'smart_neighbourhood.db');
      final file = File(path);
      return file.existsSync() ? await file.length() : 0;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return {
      'Authorization': 'Bearer ${token ?? ''}',
      'Content-Type': 'application/json',
    };
  }
}
