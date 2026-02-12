import 'package:flutter/material.dart';
import '../../core/services/sync_service_locator.dart';

/// Widget that displays sync status and provides sync actions
class SyncStatusWidget extends StatefulWidget {
  const SyncStatusWidget({super.key});

  @override
  State<SyncStatusWidget> createState() => _SyncStatusWidgetState();
}

class _SyncStatusWidgetState extends State<SyncStatusWidget> {
  bool _isSyncing = false;

  /// Perform sync for all services
  Future<void> _syncAll() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      await SyncServiceLocator.syncAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!SyncServiceLocator.isInitialized) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: InkWell(
        onTap: _isSyncing ? null : _syncAll,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSyncing)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.sync,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              const SizedBox(width: 4),
              Text(
                _isSyncing ? 'Syncing...' : 'Sync',
                style: TextStyle(
                  fontSize: 12,
                  color: _isSyncing
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple sync button that can be added to any screen
class SyncButton extends StatefulWidget {
  final VoidCallback? onSyncComplete;
  final String? tooltip;

  const SyncButton({super.key, this.onSyncComplete, this.tooltip});

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> {
  bool _isSyncing = false;

  Future<void> _sync() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      await SyncServiceLocator.syncAll();
      widget.onSyncComplete?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isSyncing ? null : _sync,
      icon: _isSyncing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
            )
          : const Icon(Icons.sync),
      tooltip: widget.tooltip ?? 'Sync data',
    );
  }
}
