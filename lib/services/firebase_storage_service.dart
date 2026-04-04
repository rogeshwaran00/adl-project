import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service for uploading images to Firebase Storage.
/// Images are stored at: uploads/{timestamp}.jpg
class FirebaseStorageService {
  static final FirebaseStorageService _instance = FirebaseStorageService._internal();
  factory FirebaseStorageService() => _instance;
  FirebaseStorageService._internal();

  final _storage = FirebaseStorage.instance;

  /// Upload [image] file to Firebase Storage.
  /// Returns the public download URL of the uploaded image.
  /// Throws on failure (caller should catch).
  Future<String> uploadImageToStorage(File image) async {
    print('UPLOADING IMAGE');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref().child('uploads/$timestamp.jpg');

    final uploadTask = ref.putFile(
      image,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    // Wait for completion
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('IMAGE UPLOADED: $downloadUrl');
    return downloadUrl;
  }
}
