import 'dart:async';
import 'package:workmanager/workmanager.dart';

/// Schedules periodic background sync operations
class BackgroundSyncScheduler {
  static const String _syncTaskName = 'smart_neighborhood_sync';
  static const String _syncTaskTag = 'sync_periodic';

  /// Schedule periodic background sync (runs every 15 minutes minimum)
  Future<void> schedulePeriodicSync({
    Duration frequency = const Duration(hours: 1),
    Duration initialDelay = const Duration(minutes: 5),
    bool requiresCharging = false,
    bool requiresWifi = false,
  }) async {
    await Workmanager().registerPeriodicTask(
      _syncTaskName,
      _syncTaskTag,
      frequency: frequency,
      initialDelay: initialDelay,
      constraints: Constraints(
        networkType: requiresWifi
            ? NetworkType.unmetered
            : NetworkType.connected,
        requiresCharging: requiresCharging,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// Schedule one-time background sync
  Future<void> scheduleOneTimeSync({
    Duration delay = Duration.zero,
    bool requiresNetwork = true,
  }) async {
    await Workmanager().registerOneOffTask(
      '${_syncTaskName}_onetime_${DateTime.now().millisecondsSinceEpoch}',
      _syncTaskTag,
      initialDelay: delay,
      constraints: Constraints(
        networkType: requiresNetwork
            ? NetworkType.connected
            : NetworkType.not_required,
      ),
    );
  }

  /// Cancel all scheduled sync tasks
  Future<void> cancelAllSyncTasks() async {
    await Workmanager().cancelByTag(_syncTaskTag);
  }

  /// Cancel specific task
  Future<void> cancelTask(String taskName) async {
    await Workmanager().cancelByUniqueName(taskName);
  }
}
