import 'dart:async';
import 'sync_models.dart';
import 'network_manager.dart';
import 'advanced_sync_engine.dart';
import 'operation_queue.dart';
import '../services/sync_service_locator.dart';

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

/// Orchestrates synchronization using existing core/sync infrastructure.
///
/// Delegates to:
/// - [NetworkManager] for connectivity checks
/// - [AdvancedSyncEngine] for the actual upload/download sync engine
/// - [OperationQueue] for queued operations count
/// - [SyncServiceLocator] for per-feature sync services
///
/// This class adds progress tracking with percentage on top of
/// the existing infrastructure, without duplicating any logic.
class SyncService {
  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();

  SyncService._();

  // === Reuse existing core infrastructure ===
  final NetworkManager _networkManager = NetworkManager.instance;
  final AdvancedSyncEngine _syncEngine = AdvancedSyncEngine.instance;
  final OperationQueue _operationQueue = OperationQueue.instance;

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

  /// Check connectivity using [NetworkManager]
  Future<bool> hasConnectivity() async {
    final quality = await _networkManager.assessNetworkQuality();
    return quality.connectionType != ConnectionType.none;
  }

  /// Check if sync is due (weekly sync)
  Future<bool> isSyncDue() async {
    if (_lastSyncTime == null) return true;
    final daysSinceLastSync = DateTime.now().difference(_lastSyncTime!).inDays;
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

  /// Perform full synchronization of all features.
  ///
  /// 1. Checks connectivity via [NetworkManager].
  /// 2. Syncs pending operations through [AdvancedSyncEngine] (upload phase).
  /// 3. Syncs each feature one-by-one via [SyncServiceLocator].
  /// 4. Emits [SyncProgressInfo] with percentage for the UI.
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

    // Use NetworkManager for connectivity check
    if (!await hasConnectivity()) {
      return SyncResult(
        status: SyncResultStatus.noConnection,
        errors: ['لا يوجد اتصال بالإنترنت'],
      );
    }

    _isSyncing = true;
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final startTime = DateTime.now();
    final errors = <String>[];
    int totalUploaded = 0;
    int totalDownloaded = 0;

    try {
      // --- Phase 1: Upload pending operations via AdvancedSyncEngine ---
      // Total steps = 1 (engine upload) + syncFeatures.length
      final totalSteps = 1 + syncFeatures.length;

      _emitProgress(
        stage: SyncStage.starting,
        message: 'جاري التحضير للمزامنة...',
        sessionId: sessionId,
        totalSteps: totalSteps,
        completedSteps: 0,
        currentFeature: 'تحميل البيانات المعلقة',
      );

      // Use AdvancedSyncEngine for the upload phase
      try {
        final pendingCount = await _operationQueue.getPendingCount();
        if (pendingCount > 0) {
          final engineResult = await _syncEngine.performIntelligentSync(
            baseUrl: baseUrl,
            authToken: authToken,
            trigger: SyncTrigger.manual,
          );
          totalUploaded += engineResult.uploadedCount;
          if (engineResult.errors.isNotEmpty) {
            errors.addAll(engineResult.errors);
          }
        }
      } catch (e) {
        errors.add('فشل في تحميل البيانات المعلقة: $e');
      }

      // --- Phase 2: Sync each feature one by one via SyncServiceLocator ---
      for (int i = 0; i < syncFeatures.length; i++) {
        final feature = syncFeatures[i];
        final featureId = feature['id']!;
        final featureName = feature['name']!;

        _emitProgress(
          stage: SyncStage.downloading,
          message: 'جاري مزامنة $featureName...',
          sessionId: sessionId,
          totalSteps: totalSteps,
          completedSteps: 1 + i, // +1 for the engine upload phase
          currentFeature: featureName,
          uploadedCount: totalUploaded,
          downloadedCount: totalDownloaded,
        );

        try {
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
          totalDownloaded++;
        } catch (e) {
          errors.add('فشل في مزامنة $featureName: $e');
        }

        // Small delay between syncs to prevent overwhelming the server
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // --- Phase 3: Complete ---
      _emitProgress(
        stage: SyncStage.completed,
        message: 'اكتملت المزامنة',
        sessionId: sessionId,
        totalSteps: totalSteps,
        completedSteps: totalSteps,
        currentFeature: '',
        uploadedCount: totalUploaded,
        downloadedCount: totalDownloaded,
      );

      _lastSyncTime = DateTime.now();

      // Record sync log
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
        errors: ['فشلت المزامنة: $e', ...errors],
        duration: DateTime.now().difference(startTime),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Helper to emit progress updates
  void _emitProgress({
    required SyncStage stage,
    required String message,
    required String sessionId,
    required int totalSteps,
    required int completedSteps,
    required String currentFeature,
    int? uploadedCount,
    int? downloadedCount,
  }) {
    _progressController.add(
      SyncProgressInfo(
        stage: stage,
        message: message,
        sessionId: sessionId,
        totalSteps: totalSteps,
        completedSteps: completedSteps,
        currentFeature: currentFeature,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
      ),
    );
  }

  /// Dispose of resources
  void dispose() {
    _progressController.close();
  }
}
