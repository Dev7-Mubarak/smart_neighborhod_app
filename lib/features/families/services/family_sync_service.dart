import 'package:flutter/foundation.dart';
import '../data/repositories/family_repository.dart';

/// Service for syncing families between local database and server
/// Handles complex relationships with family members and categories
class FamilySyncService {
  final FamilyRepository repository;

  FamilySyncService(this.repository);

  /// Upload pending families and family members, then download latest from server
  Future<Map<String, dynamic>> syncAll() async {
    try {
      // Sync families first
      final familyResult = await repository.syncFamilies();

      // Then sync family members
      final memberResult = await repository.syncFamilyMembers();

      // Also sync lookup data (categories and roles)
      await repository.syncCategories();
      await repository.syncRoles();

      final totalUploaded =
          familyResult.uploadedCount + memberResult.uploadedCount;
      final totalDownloaded =
          familyResult.downloadedCount + memberResult.downloadedCount;
      final allErrors = [...familyResult.errors, ...memberResult.errors];

      return {
        'success': familyResult.success && memberResult.success,
        'uploadedCount': totalUploaded,
        'downloadedCount': totalDownloaded,
        'errors': allErrors,
      };
    } catch (e) {
      debugPrint('Error in FamilySyncService.syncAll: $e');
      return {
        'success': false,
        'uploadedCount': 0,
        'downloadedCount': 0,
        'errors': ['Sync failed: $e'],
      };
    }
  }

  /// Get count of pending items that need syncing
  Future<int> getPendingCount() async {
    try {
      return await repository.getPendingFamiliesCount();
    } catch (e) {
      debugPrint('Error getting pending count: $e');
      return 0;
    }
  }
}
