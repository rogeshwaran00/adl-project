import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_theme.dart';
import '../../services/api_service.dart';

class AdminExportReportScreen extends StatefulWidget {
  const AdminExportReportScreen({super.key});

  @override
  State<AdminExportReportScreen> createState() => _AdminExportReportScreenState();
}

class _AdminExportReportScreenState extends State<AdminExportReportScreen> {
  String _format = 'pdf';
  bool _isExporting = false;
  bool _exported = false;
  String? _error;

  String get _dateText => DateFormat('dd MMM yyyy').format(DateTime.now());

  Future<void> _handleExport() async {
    setState(() { _error = null; _exported = false; _isExporting = true; });
    try {
      await ApiService.apiDownload('/api/admin/reports/export?format=$_format');
      setState(() => _exported = true);
    } catch (_) {
      setState(() => _error = 'Unable to export report from backend. Please verify API is running.');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                  label: const Text('Back to Dashboard', style: TextStyle(color: Colors.white, fontSize: 13)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.file_download, size: 24, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Tools', style: TextStyle(color: Colors.green[100], fontSize: 11)),
                        const Text('Export Report',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Report Period
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Report period', style: TextStyle(fontSize: 13, color: AppTheme.gray500)),
                        const SizedBox(height: 16),
                        Text('Current snapshot ($_dateText)',
                            style: const TextStyle(fontSize: 15, color: AppTheme.gray800, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Format Selection
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select format',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray700)),
                        const SizedBox(height: 16),
                        _formatOption('pdf', Icons.picture_as_pdf, 'PDF'),
                        const SizedBox(height: 16),
                        _formatOption('csv', Icons.table_chart, 'CSV'),
                        const SizedBox(height: 16),
                        _formatOption('xlsx', Icons.grid_on, 'Excel (XLSX)'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Export Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isExporting ? null : _handleExport,
                      icon: _isExporting
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.download, color: Colors.white),
                      label: Text(
                        _isExporting ? 'Exporting...' : 'Export ${_format.toUpperCase()} Report',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: AppTheme.elevatedSolid(AppTheme.green600),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status messages
                  if (_exported)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.green600, size: 18),
                          SizedBox(width: 10),
                          Text('Report downloaded successfully.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF15803D))),
                        ],
                      ),
                    ),
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        border: Border.all(color: const Color(0xFFFECACA)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppTheme.red600, size: 18),
                          const SizedBox(width: 10),
                          Expanded(child: Text(_error!, style: const TextStyle(fontSize: 12, color: AppTheme.red600))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: child,
    );
  }

  Widget _formatOption(String value, IconData icon, String label) {
    final selected = _format == value;
    return GestureDetector(
      onTap: () => setState(() => _format = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FDF4) : Colors.white,
          border: Border.all(color: selected ? AppTheme.green600 : AppTheme.gray200, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? AppTheme.green600 : AppTheme.gray500),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 14, color: selected ? AppTheme.green600 : AppTheme.gray700,
                      fontWeight: selected ? FontWeight.w500 : FontWeight.normal)),
            ),
            if (selected) const Icon(Icons.check_circle, color: AppTheme.green600, size: 18),
          ],
        ),
      ),
    );
  }
}
