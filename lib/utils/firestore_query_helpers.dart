import 'package:flutter/material.dart';

/// Detects Firestore "create this index" failures (client needs composite index).
bool isFirestoreIndexError(Object? error) {
  final s = error?.toString() ?? '';
  return s.contains('failed-precondition') ||
      s.contains('requires an index') ||
      s.contains('The query requires an index');
}

/// User-facing copy; optional [technical] shown in smaller text.
String firestoreErrorSummary(Object? error) {
  if (error == null) return 'Unknown error';
  if (isFirestoreIndexError(error)) {
    return 'A database index is required for this list. '
        'Use the link in the debug details below (or deploy firestore.indexes.json), '
        'then try again.';
  }
  return error.toString();
}

/// Tries to pull the Firebase console URL from the plugin error string.
String? extractFirestoreIndexUrl(String errorString) {
  final re = RegExp(r'https://console\.firebase\.google\.com[^\s\)]+');
  final m = re.firstMatch(errorString);
  return m?.group(0);
}

/// Non-crashing error panel for StreamBuilder Firestore failures.
class FirestoreStreamErrorPanel extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;

  const FirestoreStreamErrorPanel({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final url = error != null ? extractFirestoreIndexUrl(error.toString()) : null;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFirestoreIndexError(error) ? Icons.table_rows : Icons.cloud_off_outlined,
              size: 56,
              color: Colors.orange.shade800,
            ),
            const SizedBox(height: 16),
            Text(
              firestoreErrorSummary(error),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF374151), height: 1.4),
            ),
            if (url != null) ...[
              const SizedBox(height: 16),
              SelectableText(
                url,
                style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB)),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              error?.toString() ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
