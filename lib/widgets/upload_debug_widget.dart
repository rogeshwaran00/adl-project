import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloudinary_service.dart';
import '../utils/firestore_test.dart';

/// Debug widget to test Cloudinary + Firestore integration step by step
class UploadDebugWidget extends StatefulWidget {
  const UploadDebugWidget({super.key});

  @override
  State<UploadDebugWidget> createState() => _UploadDebugWidgetState();
}

class _UploadDebugWidgetState extends State<UploadDebugWidget> {
  final _cloudinary = CloudinaryService();
  final _picker = ImagePicker();

  File? _image;
  String? _cloudinaryUrl;
  bool _isUploading = false;
  String _debugLog = '';
  Map<String, dynamic>? _firestoreData;

  void _addLog(String message) {
    setState(() {
      _debugLog += '${DateTime.now().toIso8601String()}: $message\n';
    });
    print(message);
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
          _cloudinaryUrl = null;
          _firestoreData = null;
        });
        _addLog('Image picked: ${picked.path}');
      }
    } catch (e) {
      _addLog('Error picking image: $e');
    }
  }

  Future<void> _testCloudinaryUpload() async {
    if (_image == null) {
      _addLog('No image selected');
      return;
    }

    setState(() => _isUploading = true);
    _addLog('Starting Cloudinary upload...');

    try {
      final url = await _cloudinary.uploadToCloudinary(_image!);
      setState(() => _cloudinaryUrl = url);
      _addLog('Cloudinary upload SUCCESS: $url');
    } catch (e) {
      _addLog('Cloudinary upload FAILED: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _testFirestoreSave() async {
    if (_cloudinaryUrl == null) {
      _addLog('No Cloudinary URL available');
      return;
    }

    _addLog('Starting Firestore save...');

    try {
      final docRef = await FirebaseFirestore.instance.collection('uploads').add({
        'imageUrl': _cloudinaryUrl,
        'loanId': 'DEBUG-TEST',
        'latitude': 12.3456,
        'longitude': 78.9012,
        'timestamp': DateTime.now().toIso8601String(),
        'userId': 'debug-user',
        'role': 'beneficiary',
        'status': 'debug-test',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _addLog('Firestore save SUCCESS: Document ID = ${docRef.id}');

      // Read back the data to verify
      final doc = await docRef.get();
      setState(() => _firestoreData = doc.data());
      _addLog('Firestore data retrieved: ${doc.data()}');

    } catch (e) {
      _addLog('Firestore save FAILED: $e');
    }
  }

  Future<void> _testCompleteFlow() async {
    if (_image == null) {
      _addLog('No image selected');
      return;
    }

    setState(() => _isUploading = true);
    _addLog('=== STARTING COMPLETE FLOW ===');

    try {
      // Step 1: Upload to Cloudinary
      _addLog('Step 1: Uploading to Cloudinary...');
      final url = await _cloudinary.uploadToCloudinary(_image!);
      setState(() => _cloudinaryUrl = url);
      _addLog('Step 1 SUCCESS: $url');

      // Step 2: Save to Firestore
      _addLog('Step 2: Saving to Firestore...');
      final docRef = await FirebaseFirestore.instance.collection('uploads').add({
        'imageUrl': url,
        'loanId': 'COMPLETE-FLOW-TEST',
        'latitude': 12.3456,
        'longitude': 78.9012,
        'timestamp': DateTime.now().toIso8601String(),
        'userId': 'complete-flow-user',
        'role': 'beneficiary',
        'status': 'complete-test',
        'createdAt': FieldValue.serverTimestamp(),
      });
      _addLog('Step 2 SUCCESS: Document ID = ${docRef.id}');

      // Step 3: Verify data
      final doc = await docRef.get();
      setState(() => _firestoreData = doc.data());
      _addLog('Step 3: Verification - Data saved: ${doc.data() != null}');
      _addLog('Step 3: imageUrl field exists: ${doc.data()?['imageUrl'] != null}');
      _addLog('Step 3: imageUrl value: ${doc.data()?['imageUrl']}');

      _addLog('=== COMPLETE FLOW SUCCESS ===');

    } catch (e) {
      _addLog('=== COMPLETE FLOW FAILED: $e ===');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _checkFirestoreConnection() async {
    _addLog('Testing Firestore connection...');

    try {
      // Try to read from uploads collection
      final query = await FirebaseFirestore.instance
          .collection('uploads')
          .limit(1)
          .get();

      _addLog('Firestore connection OK. Found ${query.docs.length} documents.');

      if (query.docs.isNotEmpty) {
        _addLog('Sample document: ${query.docs.first.data()}');
      }

    } catch (e) {
      _addLog('Firestore connection FAILED: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Debug')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview
            if (_image != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),

            const SizedBox(height: 16),

            // Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('1. Pick Image'),
                ),
                ElevatedButton(
                  onPressed: _isUploading ? null : _testCloudinaryUpload,
                  child: _isUploading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator())
                      : const Text('2. Test Cloudinary'),
                ),
                ElevatedButton(
                  onPressed: _testFirestoreSave,
                  child: const Text('3. Test Firestore Save'),
                ),
                ElevatedButton(
                  onPressed: _isUploading ? null : _testCompleteFlow,
                  child: const Text('4. Complete Flow Test'),
                ),
                ElevatedButton(
                  onPressed: _checkFirestoreConnection,
                  child: const Text('Check Firestore'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _addLog('Running Firestore test...');
                    await testFirestoreConnection();
                  },
                  child: const Text('Test Firestore Save'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Results
            if (_cloudinaryUrl != null) ...[
              const Text('Cloudinary URL:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_cloudinaryUrl!, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
            ],

            if (_firestoreData != null) ...[
              const Text('Firestore Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _firestoreData.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Debug Log
            const Text('Debug Log:', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: SelectableText(
                  _debugLog,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}