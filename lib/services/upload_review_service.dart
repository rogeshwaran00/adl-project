import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_session.dart';

/// Firestore updates for upload approval — **officers only** (enforced in app + here).
class UploadReviewService {
  UploadReviewService._();
  static final UploadReviewService instance = UploadReviewService._();

  /// Throws if the current session is not allowed to review.
  void _assertOfficerMayReview() {
    if (!AppSession.canReviewUploads) {
      throw StateError(
        'Only a logged-in field officer may approve or reject uploads. '
        'Admins have read-only access.',
      );
    }
  }

  /// Sets [status] to `approved` or `rejected`, plus [reviewedBy] and [reviewedAt].
  Future<void> updateUploadReviewStatus({
    required String docId,
    required String status,
  }) async {
    if (status != 'approved' && status != 'rejected') {
      throw ArgumentError('status must be approved or rejected');
    }

    _assertOfficerMayReview();
    final reviewerId = AppSession.officerId!.trim();

    try {
      await FirebaseFirestore.instance.collection('uploads').doc(docId).update({
        'status': status,
        'reviewedBy': reviewerId,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      print('UploadReviewService.updateUploadReviewStatus failed: $e\n$st');
      rethrow;
    }
  }

  /// Approve upload — **officer only**. [officerId] must match [AppSession.officerId].
  Future<void> approveUpload({
    required String documentId,
    required String officerId,
  }) {
    _ensureOfficerIdMatches(officerId);
    return updateUploadReviewStatus(docId: documentId, status: 'approved');
  }

  /// Reject upload — **officer only**. [officerId] must match [AppSession.officerId].
  Future<void> rejectUpload({
    required String documentId,
    required String officerId,
  }) {
    _ensureOfficerIdMatches(officerId);
    return updateUploadReviewStatus(docId: documentId, status: 'rejected');
  }

  void _ensureOfficerIdMatches(String officerId) {
    _assertOfficerMayReview();
    final session = AppSession.officerId!.trim();
    if (officerId.trim() != session) {
      throw StateError('officerId does not match the logged-in officer.');
    }
  }
}
