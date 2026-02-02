part of 'sync_cubit.dart';

/// Base state for sync management
abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SyncInitial extends SyncState {
  const SyncInitial();
}

/// Checking sync status
class SyncChecking extends SyncState {
  const SyncChecking();
}

/// Sync status loaded
class SyncStatusLoaded extends SyncState {
  final bool isSyncDue;
  final bool hasConnection;
  final SyncLog? lastSync;
  final Duration? timeUntilNextSync;

  const SyncStatusLoaded({
    required this.isSyncDue,
    required this.hasConnection,
    this.lastSync,
    this.timeUntilNextSync,
  });

  String get lastSyncText {
    if (lastSync == null) return 'Never synced';
    final date = lastSync!.completedAt ?? lastSync!.startedAt;
    return 'Last sync: ${_formatDate(date)}';
  }

  String get nextSyncText {
    if (timeUntilNextSync == null) return 'Sync now recommended';
    if (timeUntilNextSync == Duration.zero) return 'Sync due now';
    return 'Next sync in: ${_formatDuration(timeUntilNextSync!)}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} minutes ago';
    if (diff.inDays < 1) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) return '${duration.inDays} days';
    if (duration.inHours > 0) return '${duration.inHours} hours';
    return '${duration.inMinutes} minutes';
  }

  @override
  List<Object?> get props => [
    isSyncDue,
    hasConnection,
    lastSync,
    timeUntilNextSync,
  ];
}

/// Sync in progress
class SyncInProgress extends SyncState {
  final SyncStage stage;
  final String message;
  final int uploadedCount;
  final int downloadedCount;

  const SyncInProgress({
    required this.stage,
    required this.message,
    this.uploadedCount = 0,
    this.downloadedCount = 0,
  });

  @override
  List<Object?> get props => [stage, message, uploadedCount, downloadedCount];
}

/// Sync completed
class SyncComplete extends SyncState {
  final SyncResult result;
  final String message;

  const SyncComplete({required this.result, required this.message});

  @override
  List<Object?> get props => [result, message];
}

/// Sync history loaded
class SyncHistoryLoaded extends SyncState {
  final List<SyncLog> history;

  const SyncHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

/// Sync error
class SyncError extends SyncState {
  final String message;

  const SyncError({required this.message});

  @override
  List<Object?> get props => [message];
}
