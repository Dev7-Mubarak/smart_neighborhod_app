import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/sync/sync_models.dart';
import 'package:smart_negborhood_app/features/sync/cubits/sync_cubit.dart';

/// Sync Manager Screen for manual sync control and monitoring
class SyncManagerScreen extends StatelessWidget {
  const SyncManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SyncCubit()..checkSyncStatus(),
      child: const _SyncManagerView(),
    );
  }
}

class _SyncManagerView extends StatelessWidget {
  const _SyncManagerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.read<SyncCubit>().loadSyncHistory(),
            tooltip: 'Sync History',
          ),
        ],
      ),
      body: BlocConsumer<SyncCubit, SyncState>(
        listener: (context, state) {
          if (state is SyncComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: state.result.isSuccess
                    ? Colors.green
                    : Colors.orange,
              ),
            );
          } else if (state is SyncError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<SyncCubit>().checkSyncStatus(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusCard(context, state),
                  const SizedBox(height: 16),
                  _buildSyncButton(context, state),
                  const SizedBox(height: 24),
                  if (state is SyncInProgress) _buildProgressCard(state),
                  if (state is SyncHistoryLoaded) _buildHistoryList(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, SyncState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(state),
                  color: _getStatusColor(state),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sync Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusMessage(state),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (state is SyncStatusLoaded) ...[
              const Divider(height: 24),
              _buildStatusRow(
                context,
                'Connection',
                state.hasConnection ? 'Online' : 'Offline',
                state.hasConnection ? Icons.wifi : Icons.wifi_off,
                state.hasConnection ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                context,
                'Last Sync',
                state.lastSyncText,
                Icons.access_time,
                Colors.blue,
              ),
              const SizedBox(height: 8),
              _buildStatusRow(
                context,
                'Schedule',
                state.nextSyncText,
                Icons.schedule,
                state.isSyncDue ? Colors.orange : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildSyncButton(BuildContext context, SyncState state) {
    final isLoading = state is SyncInProgress || state is SyncChecking;
    final isEnabled = state is SyncStatusLoaded && state.hasConnection;

    return ElevatedButton.icon(
      onPressed: isLoading || !isEnabled ? null : () => _performSync(context),
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.sync),
      label: Text(isLoading ? 'Syncing...' : 'Sync Now'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildProgressCard(SyncInProgress state) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 12),
                Text(
                  state.message,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCountBadge(
                  'Uploaded',
                  state.uploadedCount,
                  Icons.cloud_upload,
                  Colors.green,
                ),
                _buildCountBadge(
                  'Downloaded',
                  state.downloadedCount,
                  Icons.cloud_download,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHistoryList(SyncHistoryLoaded state) {
    if (state.history.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No sync history yet')),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Sync History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.history.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = state.history[index];
              final isSuccess =
                  log.status == SyncResultStatus.success ||
                  log.status == SyncResultStatus.partialSuccess;

              return ListTile(
                leading: Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                title: Text(
                  _formatDateTime(log.startedAt),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '↑ ${log.uploadedCount} uploaded, ↓ ${log.downloadedCount} downloaded',
                ),
                trailing: Text(
                  log.status.name,
                  style: TextStyle(
                    color: isSuccess ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(SyncState state) {
    if (state is SyncInProgress) return Icons.sync;
    if (state is SyncStatusLoaded) {
      if (!state.hasConnection) return Icons.cloud_off;
      if (state.isSyncDue) return Icons.sync_problem;
      return Icons.cloud_done;
    }
    if (state is SyncError) return Icons.error;
    return Icons.cloud_queue;
  }

  Color _getStatusColor(SyncState state) {
    if (state is SyncInProgress) return Colors.blue;
    if (state is SyncStatusLoaded) {
      if (!state.hasConnection) return Colors.grey;
      if (state.isSyncDue) return Colors.orange;
      return Colors.green;
    }
    if (state is SyncError) return Colors.red;
    return Colors.grey;
  }

  String _getStatusMessage(SyncState state) {
    if (state is SyncInProgress) return state.message;
    if (state is SyncStatusLoaded) {
      if (!state.hasConnection) return 'No internet connection';
      if (state.isSyncDue) return 'Sync is due';
      return 'All data is synchronized';
    }
    if (state is SyncError) return state.message;
    if (state is SyncChecking) return 'Checking status...';
    return 'Loading...';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _performSync(BuildContext context) {
    // In production, get these from your configuration service
    const baseUrl = 'https://your-api-server.com';
    // Get auth token from secure storage in production

    context.read<SyncCubit>().performSync(
      baseUrl: baseUrl,
      authToken: null, // Get from secure storage
    );
  }
}
