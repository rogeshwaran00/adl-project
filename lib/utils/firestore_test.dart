import 'package:cloud_firestore/cloud_firestore.dart';

/// Quick test to verify Firestore connection and data saving
Future<void> testFirestoreConnection() async {
  print('🔥 Testing Firestore connection...');

  try {
    // Test 1: Check if we can connect
    final testDoc = await FirebaseFirestore.instance.collection('test').add({
      'message': 'Connection test',
      'timestamp': DateTime.now().toIso8601String(),
    });
    print('✅ Firestore connection OK - Test doc created: ${testDoc.id}');

    // Test 2: Save a sample upload record
    final uploadDoc = await FirebaseFirestore.instance.collection('uploads').add({
      'imageUrl': 'https://example.com/test-image.jpg',
      'loanId': 'TEST-123',
      'latitude': 12.3456,
      'longitude': 78.9012,
      'timestamp': DateTime.now().toIso8601String(),
      'userId': 'test-user',
      'role': 'beneficiary',
      'status': 'test',
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('✅ Upload record saved: ${uploadDoc.id}');

    // Test 3: Read back the data
    final doc = await uploadDoc.get();
    final data = doc.data();
    print('✅ Data retrieved: ${data != null}');
    print('✅ imageUrl field: ${data?['imageUrl']}');

    // Clean up test data
    await testDoc.delete();
    await uploadDoc.delete();
    print('🧹 Test data cleaned up');

  } catch (e) {
    print('❌ Firestore test FAILED: $e');
  }
}