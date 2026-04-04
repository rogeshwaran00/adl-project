import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_theme.dart';
import '../../services/connectivity_service.dart';
import '../../services/storage_service.dart';

/// Dedicated screen showing full upload history (pending + uploaded).
/// Features:
/// - Real-time connectivity status
/// - "Retry All" manual sync button
/// - Delete individual pending uploads
/// - Auto-refreshes when sync completes
class PendingUploadsScreen extends StatefulWidget {
  const PendingUploadsScreen({super.key});

  @override
  State<PendingUploadsScreen> createState() => _PendingUploadsScreenState();
}

class _PendingUploadsScreenState extends State<PendingUploadsScreen> {
  final _storage = StorageService();
  final _connectivity = ConnectivityService();

  List<PendingUpload> _allUploads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUploads();
    _connectivity.addListener(_onConnectivityChanged);
    _connectivity.onSyncComplete = _loadUploads;
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    _connectivity.onSyncComplete = null;
    super.dispose();
  }

  void _onConnectivityChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadUploads() async {
    final uploads = await _storage.getAllUploads();
    if (mounted) {
      setState(() {
        _allUploads = uploads;
        _isLoading = false;
      });
    }
  }

  List<PendingUpload> get _pending => _allUploads.where((u) => u.status == 'pending').toList();
  List<PendingUpload> get _uploaded => _allUploads.where((u) => u.status == 'uploaded').toList();

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  label: const Text('Back', style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Upload History',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _connectivity.isOnline ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _connectivity.isOnline ? Icons.wifi : Icons.wifi_off,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _connectivity.isOnline ? 'ONLINE' : 'OFFLINE',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_pending.length} pending · ${_uploaded.length} uploaded',
                  style: TextStyle(color: Colors.blue[100], fontSize: 13),
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allUploads.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadUploads,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Syncing indicator
                              if (_connectivity.isSyncing)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    border: Border.all(color: const Color(0xFFBFDBFE)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: const [
                                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                                      SizedBox(width: 10),
                                      Text('Syncing pending uploads…',
                                          style: TextStyle(fontSize: 12, color: AppTheme.blue600)),
                                    ],
                                  ),
                                ),

                              // Retry All button (only if pending items exist and online)
                              if (_pending.isNotEmpty && _connectivity.isOnline && !_connectivity.isSyncing)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.blueHeader,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: AppTheme.blue600.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await _connectivity.manualSync();
                                      await _loadUploads();
                                    },
                                    icon: const Icon(Icons.sync, color: Colors.white),
                                    label: Text('Retry All (${_pending.length} pending)',
                                        style: const TextStyle(color: Colors.white)),
                                    style: AppTheme.elevatedOnGradient(),
                                  ),
                                ),

                              // Pending section
                              if (_pending.isNotEmpty) ...[
                                _buildSectionHeader('Pending', _pending.length, Colors.orange),
                                const SizedBox(height: 12),
                                ..._pending.map((u) => _buildUploadCard(u, isPending: true)),
                                const SizedBox(height: 24),
                              ],

                              // Uploaded section
                              if (_uploaded.isNotEmpty) ...[
                                _buildSectionHeader('Uploaded', _uploaded.length, AppTheme.green600),
                                const SizedBox(height: 12),
                                ..._uploaded.map((u) => _buildUploadCard(u, isPending: false)),
                              ],
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
            child: const Icon(Icons.cloud_done, size: 48, color: AppTheme.blue600),
          ),
          const SizedBox(height: 24),
          const Text('No uploads yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.gray700)),
          const SizedBox(height: 8),
          const Text('Captured proofs will appear here',
              style: TextStyle(fontSize: 13, color: AppTheme.gray500)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.gray800)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }

  Widget _buildUploadCard(PendingUpload upload, {required bool isPending}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPending ? const Color(0xFFFED7AA) : const Color(0xFFBBF7D0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // Uploaded records: imagePath is a Cloudinary URL → show network image.
              // Pending records:  imagePath is a local file path  → show file image.
              child: !isPending && upload.imagePath.startsWith('http')
                  ? Image.network(
                      upload.imagePath,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, p) => p == null
                          ? child
                          : Container(
                              width: 64, height: 64,
                              color: Colors.grey[200],
                              child: const Center(
                                child: SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                      errorBuilder: (_, __, ___) => Container(
                          width: 64, height: 64,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey)),
                    )
                  : Image.file(
                      File(upload.localPath ?? upload.imagePath),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 64, height: 64,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey)),
                    ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(upload.loanName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.gray800)),
                  const SizedBox(height: 4),
                  Text('Loan: ${upload.loanId}', style: const TextStyle(fontSize: 11, color: AppTheme.gray500)),
                  const SizedBox(height: 2),
                  Text(_formatDate(upload.timestamp), style: const TextStyle(fontSize: 11, color: AppTheme.gray500)),
                  const SizedBox(height: 2),
                  Text(
                    'GPS: ${upload.latitude.toStringAsFixed(4)}, ${upload.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 10, color: AppTheme.gray400),
                  ),
                  const SizedBox(height: 6),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPending ? Colors.orange.withOpacity(0.1) : AppTheme.green600.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPending ? Icons.schedule : Icons.check_circle,
                          size: 12,
                          color: isPending ? Colors.orange : AppTheme.green600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isPending ? 'Pending' : 'Uploaded',
                          style: TextStyle(
                            fontSize: 11,
                            color: isPending ? Colors.orange[800] : AppTheme.green600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Delete button (pending only)
            if (isPending)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.red600),
                onPressed: () async {
                  await _storage.deleteUpload(upload.id!);
                  _loadUploads();
                },
              ),
          ],
        ),
      ),
    );
  }
}
