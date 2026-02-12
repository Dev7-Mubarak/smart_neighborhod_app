import '../../features/confilct/services/conflict_sync_service.dart';
import '../../features/families/services/family_sync_service.dart';
import '../../features/issues/services/issue_sync_service.dart';
import '../config/injection.dart';

/// Global service locator for sync services
/// Provides access to all sync services throughout the app
class SyncServiceLocator {
  static IssueSyncService? _issueSyncService;

  /// Initialize all sync services
  static Future<void> init() async {
    // ConflictSyncService and FamilySyncService are now managed by GetIt
    // Only initialize services not yet in GetIt
    _issueSyncService = const IssueSyncService();
  }

  /// Get the ConflictSyncService instance from GetIt
  static ConflictSyncService get conflictSyncService {
    return getIt<ConflictSyncService>();
  }

  /// Get the FamilySyncService instance from GetIt
  static FamilySyncService get familySyncService {
    return getIt<FamilySyncService>();
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
      getIt.isRegistered<ConflictSyncService>() &&
      getIt.isRegistered<FamilySyncService>() &&
      _issueSyncService != null;

  /// Perform sync for all services
  static Future<void> syncAll() async {
    if (!isInitialized) {
      throw StateError(
        'SyncServiceLocator not initialized. Call SyncServiceLocator.init() first.',
      );
    }

    await Future.wait([
      conflictSyncService.syncAll(),
      familySyncService.syncAll(),
      // Note: IssueSyncService sync can be added when implemented
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
    _issueSyncService = null;
    // ConflictSyncService and FamilySyncService are managed by GetIt
    // They will be disposed when GetIt is reset
  }
}
