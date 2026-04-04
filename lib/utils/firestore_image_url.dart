/// Resolves a displayable image URL from Firestore upload documents.
///
/// **Correct field:** `imageUrl` — Cloudinary `secure_url` (https://...).
/// Some legacy docs may have mistakenly used `imagePath` for a URL; we only
/// treat it as a URL if it starts with `http` (never use local `/data/...` paths).
String? resolveFirestoreImageUrl(Map<String, dynamic> data) {
  final direct = data['imageUrl'];
  if (direct is String && direct.trim().isNotEmpty) {
    final u = direct.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
  }
  // Legacy / mistaken field name — only accept if it looks like a remote URL
  final legacy = data['imagePath'];
  if (legacy is String && legacy.trim().isNotEmpty) {
    final u = legacy.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
  }
  return null;
}
