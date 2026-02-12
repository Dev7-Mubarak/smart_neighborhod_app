import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_color.dart';
import '../../cubits/sync_cubit.dart';

/// A dialog that shows synchronization progress with percentage
class SyncProgressDialog extends StatelessWidget {
  const SyncProgressDialog({super.key});

  /// Show the sync progress dialog
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SyncProgressDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncCubit, SyncState>(
      listener: (context, state) {
        if (state is SyncComplete || state is SyncError) {
          Navigator.of(context).pop();
          _showResultSnackBar(context, state);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, SyncState state) {
    if (state is SyncInProgress) {
      return _buildProgressContent(context, state);
    }
    return _buildInitialContent(context);
  }

  Widget _buildInitialContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        CircularProgressIndicator(color: AppColor.primaryColor),
        const SizedBox(height: 24),
        const Text(
          'جاري التحضير للمزامنة...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProgressContent(BuildContext context, SyncInProgress state) {
    final progressValue = state.progressPercent / 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        // Sync icon with animation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.sync, size: 48, color: AppColor.primaryColor),
        ),
        const SizedBox(height: 24),
        // Title
        const Text(
          'جاري المزامنة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Current feature being synced
        if (state.currentFeature.isNotEmpty)
          Text(
            state.currentFeature,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        const SizedBox(height: 24),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
          ),
        ),
        const SizedBox(height: 12),
        // Percentage text
        Text(
          '${state.progressPercent}%',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        // Status message
        Text(
          state.message,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Step counter
        Text(
          '${state.completedSteps} / ${state.totalSteps}',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showResultSnackBar(BuildContext context, SyncState state) {
    if (state is SyncComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else if (state is SyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}

/// A widget that shows sync confirmation snackbar
class SyncConfirmationSnackBar {
  /// Show a snackbar asking user to confirm sync
  static void show(BuildContext context, VoidCallback onConfirm) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'تأكد من اتصالك بإنترنت قوي قبل المتابعة',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'متابعة',
          textColor: Colors.white,
          onPressed: onConfirm,
        ),
      ),
    );
  }
}
