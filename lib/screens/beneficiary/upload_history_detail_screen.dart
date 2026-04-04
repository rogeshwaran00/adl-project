import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/app_session.dart';
import '../../services/upload_review_service.dart';
import '../../services/upload_history_query.dart';
import '../../utils/app_theme.dart';
import '../../utils/firestore_image_url.dart';

/// Full-screen detail for one upload document (Firestore-backed, live updates).
///
/// **Officers** (logged-in field officer): Approve / Reject when `status == pending`.
/// **Admins / beneficiaries**: read-only (no action buttons).
class UploadHistoryDetailScreen extends StatefulWidget {
  final String docId;

  const UploadHistoryDetailScreen({super.key, required this.docId});

  @override
  State<UploadHistoryDetailScreen> createState() => _UploadHistoryDetailScreenState();
}

class _UploadHistoryDetailScreenState extends State<UploadHistoryDetailScreen> {
  /// Blocks double-submit while a write is in flight.
  bool _isSubmitting = false;

  String _formatTimestamp(dynamic value) {
    if (value == null) return '—';
    try {
      if (value is Timestamp) {
        return DateFormat('dd MMM yyyy, hh:mm a').format(value.toDate());
      }
      return DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(value.toString()));
    } catch (_) {
      return value.toString();
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return AppTheme.green600;
      case 'rejected':
        return AppTheme.red600;
      default:
        return Colors.orange.shade700;
    }
  }

  /// Only field officers may see approve/reject; only while upload is still pending.
  bool _showOfficerActions(String status) {
    if (status != 'pending') return false;
    if (AppSession.role != AppRole.officer) return false;
    return AppSession.canReviewUploads;
  }

  Future<void> _confirmAndAct(BuildContext context, {required bool approve}) async {
    final officerId = AppSession.officerId;
    if (officerId == null || officerId.isEmpty) {
      _snack(context, 'Officer session invalid.', isError: true);
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(approve ? 'Approve submission?' : 'Reject submission?'),
        content: Text(
          approve
              ? 'This will mark the upload as approved and record your officer ID.'
              : 'This will mark the upload as rejected and record your officer ID.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: approve ? AppTheme.green600 : AppTheme.red600,
            ),
            child: Text(approve ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _isSubmitting = true);
    try {
      final svc = UploadReviewService.instance;
      if (approve) {
        await svc.approveUpload(documentId: widget.docId, officerId: officerId);
      } else {
        await svc.rejectUpload(documentId: widget.docId, officerId: officerId);
      }
      if (!mounted || !context.mounted) return;
      _snack(context, approve ? 'Upload approved.' : 'Upload rejected.');
    } catch (e) {
      if (mounted && context.mounted) {
        _snack(context, 'Update failed: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _snack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.red600 : AppTheme.green600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: UploadHistoryQuery.uploadDocumentStream(widget.docId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorBody(message: '${snapshot.error}', onBack: () => Navigator.pop(context));
          }
          final doc = snapshot.data;
          if (doc == null || !doc.exists || doc.data() == null) {
            return _ErrorBody(message: 'This upload no longer exists.', onBack: () => Navigator.pop(context));
          }
          final data = doc.data()!;
          final status = (data['status'] as String?) ?? 'pending';
          final imageUrl = resolveFirestoreImageUrl(data);
          final loanId = data['loanId'] as String? ?? '—';
          final lat = data['latitude'];
          final lng = data['longitude'];
          final ts = data['createdAt'] ?? data['timestamp'];
          final reviewedBy = data['reviewedBy'] as String?;
          final reviewedAt = data['reviewedAt'];

          final statusColor = _statusColor(status);
          final showActions = _showOfficerActions(status);
          final disabled = _isSubmitting || status != 'pending';

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 280,
                      pinned: true,
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'Loan $loanId',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, shadows: [
                            Shadow(color: Colors.black45, blurRadius: 8),
                          ]),
                        ),
                        background: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, p) => p == null
                                    ? child
                                    : Container(
                                        color: AppTheme.gray800,
                                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                                      ),
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppTheme.gray700,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
                                ),
                              )
                            : Container(
                                color: AppTheme.gray700,
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 64),
                              ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StatusPill(status: status, color: statusColor),
                            if (AppSession.role == AppRole.admin) ...[
                              const SizedBox(height: 12),
                              _ReadOnlyBanner(
                                text: 'Admin view — approvals are performed by field officers only.',
                                color: const Color(0xFF7C3AED),
                              ),
                            ],
                            if (AppSession.role == AppRole.beneficiary) ...[
                              const SizedBox(height: 12),
                              _ReadOnlyBanner(
                                text: 'Your submission — review is done by an officer.',
                                color: AppTheme.blue600,
                              ),
                            ],
                            const SizedBox(height: 20),
                            _InfoCard(
                              children: [
                                _row(Icons.tag, 'Loan ID', loanId),
                                const Divider(height: 24),
                                _row(Icons.schedule, 'Submitted', _formatTimestamp(ts)),
                                if (lat != null && lng != null) ...[
                                  const Divider(height: 24),
                                  _row(Icons.location_on, 'GPS',
                                      '${(lat as num).toStringAsFixed(6)}, ${(lng as num).toStringAsFixed(6)}'),
                                ],
                                if (reviewedBy != null || reviewedAt != null) ...[
                                  const Divider(height: 24),
                                  if (reviewedBy != null) _row(Icons.badge_outlined, 'Reviewed by', reviewedBy),
                                  if (reviewedAt != null) ...[
                                    const SizedBox(height: 12),
                                    _row(Icons.event_available, 'Reviewed at', _formatTimestamp(reviewedAt)),
                                  ],
                                ],
                              ],
                            ),
                            if (imageUrl != null) ...[
                              const SizedBox(height: 16),
                              Text('Image URL',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray500)),
                              const SizedBox(height: 8),
                              SelectableText(imageUrl,
                                  style: const TextStyle(fontSize: 11, color: AppTheme.blue600, height: 1.4)),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showActions)
                Material(
                  elevation: 8,
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: disabled ? null : () => _confirmAndAct(context, approve: false),
                              icon: const Icon(Icons.cancel_outlined, color: AppTheme.red600),
                              label: const Text('Reject', style: TextStyle(color: AppTheme.red600, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: AppTheme.red600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: disabled ? null : () => _confirmAndAct(context, approve: true),
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.check_circle_outline, color: Colors.white),
                              label: Text(_isSubmitting ? 'Saving…' : 'Approve'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.green600,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.gray500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.gray500, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, color: AppTheme.gray800, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      );
}

class _ReadOnlyBanner extends StatelessWidget {
  final String text;
  final Color color;

  const _ReadOnlyBanner({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: color.withOpacity(0.95)))),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onBack;

  const _ErrorBody({required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back), color: AppTheme.gray800),
            ),
            const Spacer(),
            const Icon(Icons.error_outline, size: 48, color: AppTheme.red600),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusPill({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = status.isEmpty ? 'Unknown' : '${status[0].toUpperCase()}${status.substring(1)}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.label_outline, size: 18, color: color),
          const SizedBox(width: 8),
          Text('Status: $label', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.gray200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );
  }
}
