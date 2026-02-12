import 'dart:async';

/// Controller for optimistic UI updates with rollback support
class OptimisticUpdateController {
  static OptimisticUpdateController? _instance;
  static OptimisticUpdateController get instance =>
      _instance ??= OptimisticUpdateController._();
  OptimisticUpdateController._();

  final _pendingUpdates = <String, _PendingUpdate>{};

  /// Perform an optimistic update with automatic rollback on failure
  ///
  /// [updateId] - Unique identifier for this update operation
  /// [localOperation] - Function that updates local state/database
  /// [remoteOperation] - Function that syncs with server
  /// [rollbackOperation] - Function to revert local changes if sync fails
  Future<T> performOptimisticUpdate<T>({
    required String updateId,
    required Future<T> Function() localOperation,
    required Future<void> Function() remoteOperation,
    required Future<void> Function() rollbackOperation,
  }) async {
    // Store rollback info
    _pendingUpdates[updateId] = _PendingUpdate(
      rollbackOperation: rollbackOperation,
      timestamp: DateTime.now(),
    );

    try {
      // Execute local operation first (optimistic update)
      final result = await localOperation();

      // Schedule remote operation in background
      _executeRemoteOperation(updateId, remoteOperation, rollbackOperation);

      return result;
    } catch (e) {
      // Local operation failed - no rollback needed
      _pendingUpdates.remove(updateId);
      rethrow;
    }
  }

  /// Execute remote operation in background
  void _executeRemoteOperation(
    String updateId,
    Future<void> Function() remoteOperation,
    Future<void> Function() rollbackOperation,
  ) {
    remoteOperation()
        .then((_) {
          // Success - remove pending update
          _pendingUpdates.remove(updateId);
        })
        .catchError((error) async {
          // Remote operation failed - rollback local changes
          try {
            await rollbackOperation();
          } catch (rollbackError) {
            // Log rollback failure
            print('Rollback failed for $updateId: $rollbackError');
          } finally {
            _pendingUpdates.remove(updateId);
          }
        });
  }

  /// Check if an update is still pending
  bool isPending(String updateId) => _pendingUpdates.containsKey(updateId);

  /// Get count of pending updates
  int get pendingCount => _pendingUpdates.length;

  /// Clear all pending updates (use with caution)
  void clearAll() => _pendingUpdates.clear();
}

class _PendingUpdate {
  final Future<void> Function() rollbackOperation;
  final DateTime timestamp;

  _PendingUpdate({required this.rollbackOperation, required this.timestamp});
}
