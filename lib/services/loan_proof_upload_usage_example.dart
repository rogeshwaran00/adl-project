// ignore_for_file: unused_element
//
// Example: correct flow — Capture → Cloudinary `secure_url` → Firestore field `imageUrl`.
// Production code should call [FirestoreUploadService.uploadLoanProof] (single pipeline).
//
// ```dart
// final file = File('/path/from/image_picker');
// final url = await FirestoreUploadService().uploadLoanProof(
//   imageFile: file,
//   loanId: 'L-1001',
//   latitude: 28.6,
//   longitude: 77.2,
//   timestamp: DateTime.now().toIso8601String(),
// );
// if (url == null) { /* show error — do not save */ }
// ```

import 'dart:io';
import 'cloudinary_service.dart';
import 'firestore_upload_service.dart';

/// Manual two-step example (prefer [FirestoreUploadService.uploadLoanProof]).
Future<void> exampleButtonFlow(File? imageFile) async {
  if (imageFile == null || !await imageFile.exists()) {
    print('❌ No image file');
    return;
  }

  try {
    final cloudinary = CloudinaryService();
    final imageUrl = await cloudinary.uploadToCloudinary(imageFile);

    if (imageUrl.isEmpty ||
        !(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      print('❌ Invalid Cloudinary URL — not saving to Firestore');
      return;
    }

    final ok = await FirestoreUploadService().saveUploadRecord(
      imageUrl: imageUrl,
      loanId: 'L-EXAMPLE',
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now().toIso8601String(),
    );

    if (ok) {
      print('✅ Saved imageUrl to Firestore: $imageUrl');
    } else {
      print('❌ Firestore save failed');
    }
  } catch (e, st) {
    print('❌ exampleButtonFlow: $e\n$st');
  }
}
