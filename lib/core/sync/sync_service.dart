import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/sync_service_locator.dart';
import 'sync_models.dart';

/// Progress information for sync operations with percentage tracking
class SyncProgressInfo extends SyncProgress {
  final int totalSteps;
  final int completedSteps;
  final String currentFeature;
  final int? uploadedCount;
  final int? downloadedCount;

  SyncProgressInfo({
    required super.stage,
    required super.message,
    required super.sessionId,
    required this.totalSteps,
    required this.completedSteps,
    required this.currentFeature,
    this.uploadedCount,
    this.downloadedCount,
  });

  /// Get the progress percentage (0.0 to 1.0)
  double get progressPercentage =>
      totalSteps > 0 ? completedSteps / totalSteps : 0.0;

  /// Get the progress percentage as an integer (0 to 100)
  int get progressPercent => (progressPercentage * 100).round();
}

/// Sync log entry for tracking sync history
class SyncLog {
  final String id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final SyncResultStatus status;
  final int uploadedCount;
  final int downloadedCount;
  final List<String> errors;

  SyncLog({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.status,
    this.uploadedCount = 0,
    this.downloadedCount = 0,
    this.errors = const [],
  });
}

/// Service for managing data synchronization
class SyncService {
  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();

  SyncService._();

  final _progressController = StreamController<SyncProgressInfo>.broadcast();
  Stream<SyncProgressInfo> get progressStream => _progressController.stream;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  DateTime? _lastSyncTime;
  final List<SyncLog> _syncHistory = [];

  /// List of features to sync with their display names
  static const List<Map<String, String>> syncFeatures = [
    {'id': 'conflicts', 'name': 'النزاعات', 'nameEn': 'Conflicts'},
    {'id': 'families', 'name': 'العائلات', 'nameEn': 'Families'},
    {'id': 'issues', 'name': 'القضايا', 'nameEn': 'Issues'},
  ];

  /// Check if device has internet connectivity
  Future<bool> hasConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Check if sync is due (weekly sync)
  Future<bool> isSyncDue() async {
    if (_lastSyncTime == null) return true;
    final daysSinceLastSync =
        DateTime.now().difference(_lastSyncTime!).inDays;
    return daysSinceLastSync >= 7;
  }

  /// Get time until next scheduled sync
  Future<Duration?> timeUntilNextSync() async {
    if (_lastSyncTime == null) return Duration.zero;
    final nextSyncTime = _lastSyncTime!.add(const Duration(days: 7));
    final timeUntil = nextSyncTime.difference(DateTime.now());
    return timeUntil.isNegative ? Duration.zero : timeUntil;
  }

  /// Get the last successful sync log
  Future<SyncLog?> getLastSuccessfulSync() async {
    try {
      return _syncHistory
          .where((log) => log.status == SyncResultStatus.success)
          .lastOrNull;
    } catch (e) {
      return null;
    }
  }

  /// Get sync history
  Future<List<SyncLog>> getSyncHistory({int limit = 20}) async {
    return _syncHistory.take(limit).toList();
  }

  /// Perform full synchronization of all features
  Future<SyncResult> performSync({
    required String baseUrl,
    String? authToken,
  }) async {
    if (_isSyncing) {
      return SyncResult(
        status: SyncResultStatus.skipped,
        errors: ['Sync already in progress'],
      );
    }

    // Check connectivity first
    if (!await hasConnectivity()) {
      return SyncResult(
        status: SyncResultStatus.failed,
        errors: ['No internet connection'],
      );
    }

    _isSyncing = true;
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final startTime = DateTime.now();
    final errors = <String>[];
    int totalUploaded = 0;
    int totalDownloaded = 0;

    try {
      final totalSteps = syncFeatures.length;

      // Emit starting progress
      _progressController.add(SyncProgressInfo(
        stage: SyncStage.uploading,
        message: 'جاري بدء المزامنة...',
        sessionId: sessionId,
        totalSteps: totalSteps,
        completedSteps: 0,
        currentFeature: '',
      ));

      // Sync each feature one by one
      for (int i = 0; i < syncFeatures.length; i++) {
        final feature = syncFeatures[i];
        final featureId = feature['id']!;
        final featureName = feature['name']!;

        // Emit progress for current feature
        _progressController.add(SyncProgressInfo(
          stage: SyncStage.uploading,
          message: 'جاري مزامنة $featureName...',
          sessionId: sessionId,
          totalSteps: totalSteps,
          completedSteps: i,
          currentFeature: featureName,
          uploadedCount: totalUploaded,
          downloadedCount: totalDownloaded,
        ));

        try {
          // Perform sync for each feature
          switch (featureId) {
            case 'conflicts':
              await SyncServiceLocator.syncConflicts();
              break;
            case 'families':
              await SyncServiceLocator.syncFamilies();
              break;
            case 'issues':
              await SyncServiceLocator.syncIssues();
              break;
          }
          totalUploaded++;
        } catch (e) {
          errors.add('فشل في مزامنة $featureName: $e');
        }

        // Small delay between syncs to prevent overwhelming the server
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Emit completion progress
      _progressController.add(SyncProgressInfo(
        stage: SyncStage.completed,
        message: 'اكتملت المزامنة',
        sessionId: sessionId,
        totalSteps: totalSteps,
        completedSteps: totalSteps,
        currentFeature: '',
        uploadedCount: totalUploaded,
        downloadedCount: totalDownloaded,
      ));

      _lastSyncTime = DateTime.now();

      // Create sync log
      final syncLog = SyncLog(
        id: sessionId,
        startedAt: startTime,
        completedAt: DateTime.now(),
        status: errors.isEmpty
            ? SyncResultStatus.success
            : SyncResultStatus.partial,
        uploadedCount: totalUploaded,
        downloadedCount: totalDownloaded,
        errors: errors,
      );
      _syncHistory.insert(0, syncLog);

      return SyncResult(
        status: errors.isEmpty
            ? SyncResultStatus.success
            : SyncResultStatus.partial,
        errors: errors,
        uploadedCount: totalUploaded,
        downloadedCount: totalDownloaded,
        duration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      return SyncResult(
        status: SyncResultStatus.failed,
        errors: ['Sync failed: $e', ...errors],
        duration: DateTime.now().difference(startTime),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Dispose of resources
  void dispose() {
    _progressController.close();
  }
}
