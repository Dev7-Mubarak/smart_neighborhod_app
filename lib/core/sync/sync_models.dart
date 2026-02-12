import 'dart:convert';

enum SyncStatus {
  pending('pending'),
  synced('synced'),
  conflict('conflict'),
  failed('failed');

  final String value;
  const SyncStatus(this.value);

  static SyncStatus fromString(String? value) {
    return SyncStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SyncStatus.pending,
    );
  }
}

enum SyncTrigger { manual, background, scheduled, appStart, netRestored }

enum SyncStage { starting, uploading, downloading, resolving, cleanup, completed }

enum SyncOperationType { create, update, delete }

enum SyncPriority { critical, essential, comprehensive, uploadOnly }

enum ConnectionType { none, wifi, mobile, ethernet, unknown }

class NetworkQuality {
  final ConnectionType connectionType;
  final int bandwidth; // in bps
  final int latency; // in ms

  const NetworkQuality({
    this.connectionType = ConnectionType.unknown,
    this.bandwidth = 0,
    this.latency = 0,
  });
}

class SyncOperation {
  final String id;
  final String entityType;
  final String entityId;
  final SyncOperationType operationType;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final int retryCount;
  final SyncPriority priority;

  SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
    this.priority = SyncPriority.essential,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'operation_type': operationType.name,
      'payload': jsonEncode(payload),
      'timestamp': timestamp.toIso8601String(),
      'retry_count': retryCount,
      'priority': priority.index,
    };
  }

  factory SyncOperation.fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id'] ?? map['operation_id'],
      entityType: map['entity_type'],
      entityId: map['entity_id'],
      operationType: _parseOperationType(map['operation_type']),
      payload: map['payload'] is String
          ? jsonDecode(map['payload'])
          : map['payload'],
      timestamp: DateTime.parse(map['timestamp'] ?? map['created_at']),
      retryCount: map['retry_count'] ?? map['attempt_count'] ?? 0,
      priority: map['priority'] is int
          ? SyncPriority.values[map['priority']]
          : SyncPriority.essential,
    );
  }

  static SyncOperationType _parseOperationType(dynamic value) {
    if (value is int) {
      return SyncOperationType.values[value];
    } else if (value is String) {
      return SyncOperationType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => SyncOperationType.update,
      );
    }
    return SyncOperationType.update;
  }
}

class SyncStats {
  final String sessionId;
  DateTime? completedAt;
  int uploadedCount = 0;
  int downloadedCount = 0;
  int conflictCount = 0;
  int resolvedConflictsCount = 0;

  SyncStats({required this.sessionId});
}

class SyncProgress {
  final SyncStage stage;
  final String message;
  final String sessionId;

  SyncProgress({
    required this.stage,
    required this.message,
    required this.sessionId,
  });
}

class SyncSession {
  final String id;
  final SyncTrigger trigger;
  final DateTime startedAt;

  SyncSession({
    required this.id,
    required this.trigger,
    required this.startedAt,
  });

  factory SyncSession.create({required SyncTrigger trigger}) {
    return SyncSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trigger: trigger,
      startedAt: DateTime.now(),
    );
  }
}

class PreSyncAssessment {
  final NetworkQuality networkQuality;
  final int batteryLevel;
  final bool isLowPowerMode;
  final int pendingOperationsCount;
  final int databaseSize;
  final bool canSync;
  final List<String> blockers;

  PreSyncAssessment({
    required this.networkQuality,
    required this.batteryLevel,
    required this.isLowPowerMode,
    required this.pendingOperationsCount,
    required this.databaseSize,
    required this.canSync,
    this.blockers = const [],
  });
}

class SyncStrategy {
  final int batchSize;
  final int concurrentRequests;
  final bool enableDeltaSync;
  final bool enableCompression;
  final SyncPriority priority;

  SyncStrategy({
    required this.batchSize,
    required this.concurrentRequests,
    required this.enableDeltaSync,
    required this.enableCompression,
    required this.priority,
  });
}

class SyncBatch {
  final String id;
  final String entityType;
  final List<SyncOperation> operations;

  SyncBatch({
    required this.id,
    required this.entityType,
    required this.operations,
  });

  factory SyncBatch.create(String entityType, List<SyncOperation> ops) {
    return SyncBatch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      entityType: entityType,
      operations: ops,
    );
  }
}

class SyncResult {
  final SyncResultStatus status;
  final List<String> errors;
  final int uploadedCount;
  final int downloadedCount;
  final int conflictsResolved;
  final Duration? duration;
  final SyncStats? syncStats;

  SyncResult({
    required this.status,
    this.errors = const [],
    this.uploadedCount = 0,
    this.downloadedCount = 0,
    this.conflictsResolved = 0,
    this.duration,
    this.syncStats,
  });

  /// Check if sync was successful
  bool get isSuccess =>
      status == SyncResultStatus.success ||
      status == SyncResultStatus.partialSuccess;
}

enum SyncResultStatus { success, failed, skipped, partial, noConnection, partialSuccess }

class BatchUploadResult {
  final int count;
  final List<String> failures;
  final List<String> errors;

  BatchUploadResult({
    required this.count,
    required this.failures,
    required this.errors,
  });
}

class MergeResult {
  final bool success;
  final bool hasConflict;
  final SyncConflict? conflict;
  final String? error;

  MergeResult({
    required this.success,
    this.hasConflict = false,
    this.conflict,
    this.error,
  });
}

class SyncConflict {
  final String id;
  final String entityType;
  final String entityId;
  final Map<String, dynamic> localRecord;
  final Map<String, dynamic> serverRecord;
  final DateTime detectedAt;

  SyncConflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.localRecord,
    required this.serverRecord,
    required this.detectedAt,
  });
}

class OperationQueueEvent {
  final String type;
  final dynamic data;
  OperationQueueEvent(this.type, this.data);
  static OperationQueueEvent operationEnqueued(SyncOperation op) =>
      OperationQueueEvent('enqueued', op);
  static OperationQueueEvent batchEnqueued(int count) =>
      OperationQueueEvent('batch_enqueued', count);
}
