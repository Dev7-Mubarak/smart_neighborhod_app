import '../data/repositories/conflict_repository.dart';

/// Service for syncing conflicts between local database and server
/// Handles upload of pending conflicts and download of server changes
class ConflictSyncService {
  final ConflictRepository? _repository;

  ConflictSyncService([this._repository]);

  /// Upload pending conflicts from local database to server
  Future<void> uploadConflicts() async {
    if (_repository == null) {
      throw StateError(
        'ConflictRepository not initialized. Call from DI container.',
      );
    }

    // Repository handles the upload logic
    final result = await _repository!.syncConflicts();

    if (!result.success) {
      throw Exception('Upload failed: ${result.errors.join(', ')}');
    }
  }

  /// Download conflicts from server and update local database
  Future<void> downloadConflicts() async {
    if (_repository == null) {
      throw StateError(
        'ConflictRepository not initialized. Call from DI container.',
      );
    }

    // Repository handles the download logic
    final result = await _repository!.syncConflicts();

    if (!result.success) {
      throw Exception('Download failed: ${result.errors.join(', ')}');
    }
  }

  /// Resolve conflicts where both local and server have changes
  Future<void> resolveConflicts() async {
    // For now, using server-wins strategy
    // Manual conflict resolution UI can be added later
    await downloadConflicts();
  }

  /// Sync all conflicts (upload then download)
  Future<void> syncAll() async {
    if (_repository == null) {
      throw StateError(
        'ConflictRepository not initialized. Call from DI container.',
      );
    }

    await _repository!.syncConflicts();
  }
}
