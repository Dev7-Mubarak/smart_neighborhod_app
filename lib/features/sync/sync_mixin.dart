import 'package:flutter/material.dart';
import '../../core/services/sync_service_locator.dart';

/// Mixin that provides sync functionality to screens/widgets
/// Usage: Add this mixin to any screen that needs sync functionality
mixin SyncMixin {
  /// Trigger sync for conflicts
  Future<void> syncConflicts(BuildContext context) async {
    try {
      await SyncServiceLocator.syncConflicts();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conflicts synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync conflicts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Trigger sync for families
  Future<void> syncFamilies(BuildContext context) async {
    try {
      await SyncServiceLocator.syncFamilies();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Families synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync families: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Trigger sync for all services
  Future<void> syncAll(BuildContext context) async {
    try {
      await SyncServiceLocator.syncAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show sync options dialog
  void showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sync Data'),
          content: const Text('Which data would you like to sync?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                syncConflicts(context);
              },
              child: const Text('Sync Conflicts'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                syncFamilies(context);
              },
              child: const Text('Sync Families'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                syncAll(context);
              },
              child: const Text('Sync All'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
