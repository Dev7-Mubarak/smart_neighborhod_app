import '../../features/confilct/services/conflict_sync_service.dart';
import '../../features/families/services/family_sync_service.dart';
import '../../features/issues/services/issue_sync_service.dart';

/// Global service locator for sync services
/// Provides access to all sync services throughout the app
class SyncServiceLocator {
  static ConflictSyncService? _conflictSyncService;
  static FamilySyncService? _familySyncService;
  static IssueSyncService? _issueSyncService;

  /// Initialize all sync services
  static Future<void> init() async {
    _conflictSyncService = ConflictSyncService();
    _familySyncService = FamilySyncService();
    _issueSyncService = const IssueSyncService();
  }

  /// Get the ConflictSyncService instance
  static ConflictSyncService get conflictSyncService {
    if (_conflictSyncService == null) {
      throw StateError(
        'SyncServiceLocator not initialized. Call SyncServiceLocator.init() first.',
      );
    }
    return _conflictSyncService!;
  }

  /// Get the FamilySyncService instance
  static FamilySyncService get familySyncService {
    if (_familySyncService == null) {
      throw StateError(
        'SyncServiceLocator not initialized. Call SyncServiceLocator.init() first.',
      );
    }
    return _familySyncService!;
  }

  /// Get the IssueSyncService instance
  static IssueSyncService get issueSyncService {
    if (_issueSyncService == null) {
      throw StateError(
        'SyncServiceLocator not initialized. Call SyncServiceLocator.init() first.',
      );
    }
    return _issueSyncService!;
  }

  /// Check if services are initialized
  static bool get isInitialized =>
      _conflictSyncService != null &&
      _familySyncService != null &&
      _issueSyncService != null;

  /// Perform sync for all services
  static Future<void> syncAll() async {
    if (!isInitialized) {
      throw StateError(
        'SyncServiceLocator not initialized. Call SyncServiceLocator.init() first.',
      );
    }

    await Future.wait([
      _conflictSyncService!.syncAll(),
      _familySyncService!.syncAll(),
      // Note: IssueSyncService doesn't have syncPending method in the current implementation
      // If needed, you can add it or handle differently
    ]);
  }

  /// Sync conflicts only
  static Future<void> syncConflicts() async {
    await conflictSyncService.syncAll();
  }

  /// Sync all families data
  static Future<void> syncFamilies() async {
    await familySyncService.syncAll();
  }

  /// Sync issues only
  static Future<void> syncIssues() async {
    await issueSyncService.syncAll();
  }

  /// Dispose all services (for testing or app cleanup)
  static void dispose() {
    _conflictSyncService = null;
    _familySyncService = null;
    _issueSyncService = null;
  }
}
