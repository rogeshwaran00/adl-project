import 'package:flutter/material.dart';
import '../services/app_session.dart';
import '../utils/app_theme.dart';

/// Approve / Reject row for a **pending** upload. Use only when the viewer may review.
///
/// Returns an empty [SizedBox.shrink] when [show] is false (e.g. admin read-only).
class OfficerUploadReviewButtons extends StatelessWidget {
  final bool show;
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const OfficerUploadReviewButtons({
    super.key,
    required this.show,
    this.isBusy = false,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    if (!AppSession.canReviewUploads) {
      return const Text(
        'Log in as a field officer to approve or reject.',
        style: TextStyle(fontSize: 12, color: AppTheme.amber600),
      );
    }
    if (isBusy) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.cancel_outlined, size: 16, color: AppTheme.red600),
            label: const Text('Reject', style: TextStyle(color: AppTheme.red600, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.red600),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onApprove,
            icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
            label: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.green600,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
