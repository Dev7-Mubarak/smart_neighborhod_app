import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/sync/sync_models.dart';

part 'sync_state.dart';

/// Cubit for managing sync operations
/// Handles weekly sync and provides UI feedback
class SyncCubit extends Cubit<SyncState> {
  final SyncService _syncService;
  StreamSubscription<SyncProgress>? _progressSubscription;

  SyncCubit({SyncService? syncService})
    : _syncService = syncService ?? SyncService.instance,
      super(const SyncInitial()) {
    _init();
  }

  void _init() {
    // Listen to sync progress
    _progressSubscription = _syncService.progressStream.listen((progress) {
      if (state is SyncInProgress) {
        emit(
          SyncInProgress(
            stage: progress.stage,
            message: progress.message,
            uploadedCount: progress.uploadedCount ?? 0,
            downloadedCount: progress.downloadedCount ?? 0,
          ),
        );
      }
    });
  }

  /// Check current sync status
  Future<void> checkSyncStatus() async {
    emit(const SyncChecking());

    try {
      final isSyncDue = await _syncService.isSyncDue();
      final hasConnection = await _syncService.hasConnectivity();
      final lastSync = await _syncService.getLastSuccessfulSync();
      final timeUntilNext = await _syncService.timeUntilNextSync();

      emit(
        SyncStatusLoaded(
          isSyncDue: isSyncDue,
          hasConnection: hasConnection,
          lastSync: lastSync,
          timeUntilNextSync: timeUntilNext,
        ),
      );
    } catch (e) {
      emit(SyncError(message: 'Failed to check sync status: $e'));
    }
  }

  /// Perform weekly sync
  Future<void> performSync({required String baseUrl, String? authToken}) async {
    if (_syncService.isSyncing) {
      emit(const SyncError(message: 'Sync already in progress'));
      return;
    }

    emit(
      const SyncInProgress(
        stage: SyncStage.starting,
        message: 'Starting synchronization...',
      ),
    );

    final result = await _syncService.performSync(
      baseUrl: baseUrl,
      authToken: authToken,
    );

    if (result.isSuccess) {
      emit(
        SyncComplete(result: result, message: 'Sync completed successfully'),
      );
    } else if (result.status == SyncResultStatus.noConnection) {
      emit(const SyncError(message: 'No internet connection available'));
    } else if (result.status == SyncResultStatus.partialSuccess) {
      emit(
        SyncComplete(
          result: result,
          message: 'Sync completed with some errors',
        ),
      );
    } else {
      emit(
        SyncError(
          message: result.errors.isNotEmpty
              ? result.errors.first
              : 'Sync failed',
        ),
      );
    }

    // Refresh status after sync
    await checkSyncStatus();
  }

  /// Get sync history
  Future<void> loadSyncHistory() async {
    emit(const SyncChecking());

    try {
      final history = await _syncService.getSyncHistory(limit: 20);
      emit(SyncHistoryLoaded(history: history));
    } catch (e) {
      emit(SyncError(message: 'Failed to load sync history: $e'));
    }
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
