/// Sync status for tracking record synchronization state
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

/// Sync operation type
enum SyncOperation { upload, download, full }

/// Sync result status
enum SyncResultStatus {
  success,
  partialSuccess,
  failed,
  noConnection,
  cancelled,
}

/// Record of a single sync operation
class SyncLog {
  final String id;
  final String syncType;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status;
  final int recordsUploaded;
  final int recordsDownloaded;
  final String? errorMessage;

  SyncLog({
    required this.id,
    required this.syncType,
    required this.startedAt,
    this.completedAt,
    required this.status,
    this.recordsUploaded = 0,
    this.recordsDownloaded = 0,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sync_type': syncType,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'status': status,
      'records_uploaded': recordsUploaded,
      'records_downloaded': recordsDownloaded,
      'error_message': errorMessage,
    };
  }

  factory SyncLog.fromMap(Map<String, dynamic> map) {
    return SyncLog(
      id: map['id'],
      syncType: map['sync_type'],
      startedAt: DateTime.parse(map['started_at']),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      status: map['status'],
      recordsUploaded: map['records_uploaded'] ?? 0,
      recordsDownloaded: map['records_downloaded'] ?? 0,
      errorMessage: map['error_message'],
    );
  }
}

/// Result of a sync operation
class SyncResult {
  final SyncResultStatus status;
  final int uploadedCount;
  final int downloadedCount;
  final List<String> errors;
  final DateTime timestamp;

  SyncResult({
    required this.status,
    this.uploadedCount = 0,
    this.downloadedCount = 0,
    this.errors = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isSuccess => status == SyncResultStatus.success;
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    return 'SyncResult(status: $status, uploaded: $uploadedCount, downloaded: $downloadedCount, errors: ${errors.length})';
  }
}
