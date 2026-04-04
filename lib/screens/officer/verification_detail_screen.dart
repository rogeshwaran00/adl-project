import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class VerificationDetailScreen extends StatefulWidget {
  final String id;

  const VerificationDetailScreen({super.key, required this.id});

  @override
  State<VerificationDetailScreen> createState() => _VerificationDetailScreenState();
}

class _VerificationDetailScreenState extends State<VerificationDetailScreen> {
  final _remarksController = TextEditingController();

  final _verification = {
    'beneficiaryName': 'Ramesh Kumar',
    'loanId': 'LN2026001234',
    'amount': 250000,
    'purpose': 'Agricultural Equipment - Tractor Purchase',
    'submittedDate': '28 Feb 2026, 10:30 AM',
    'imageUrl': 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=800',
    'location': '28.6139°N, 77.2090°E',
    'locationName': 'Near Kharkhoda, Haryana',
    'timestamp': '28 Feb 2026, 10:28 AM',
    'description': 'New John Deere 5050D Tractor purchased from authorized dealer. Serial Number: JD5050D123456. Color: Green. Condition: Brand New.',
    'aiConfidence': 92,
    'aiChecks': [
      {'check': 'Image Quality', 'result': 'High', 'passed': true},
      {'check': 'GPS Authenticity', 'result': 'Verified', 'passed': true},
      {'check': 'Timestamp Valid', 'result': 'Within Range', 'passed': true},
      {'check': 'Asset Match', 'result': 'Agricultural Equipment', 'passed': true},
      {'check': 'Duplicate Check', 'result': 'No Duplicates Found', 'passed': true},
    ],
  };

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _handleAction(String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(action == 'approve'
            ? 'Approve Submission?'
            : action == 'reject'
                ? 'Reject Submission?'
                : 'Request Resubmission?'),
        content: Text(_remarksController.text.isEmpty
            ? 'No remarks provided.'
            : 'Remarks: ${_remarksController.text}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/officer-dashboard');
            },
            style: AppTheme.elevatedDialogAction(
              action == 'approve'
                  ? AppTheme.green600
                  : action == 'reject'
                      ? AppTheme.red600
                      : AppTheme.amber600,
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final confidence = _verification['aiConfidence'] as int;
    final aiChecks = _verification['aiChecks'] as List;

    Color confidenceColor;
    Color confidenceBg;
    if (confidence >= 80) {
      confidenceColor = AppTheme.green600;
      confidenceBg = const Color(0xFFF0FDF4);
    } else if (confidence >= 60) {
      confidenceColor = AppTheme.amber600;
      confidenceBg = const Color(0xFFFFFBEB);
    } else {
      confidenceColor = AppTheme.red600;
      confidenceBg = const Color(0xFFFEF2F2);
    }

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
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
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  label: const Text('Back to Dashboard', style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 16),
                const Text('Verification Details',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Beneficiary Info
                  _card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.person, size: 20, color: AppTheme.blue600),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_verification['beneficiaryName'] as String,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                                  Text('ID: ${_verification['loanId']}',
                                      style: const TextStyle(fontSize: 11, color: AppTheme.gray500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Expanded(child: _infoItem(Icons.currency_rupee, 'Loan Amount',
                                '₹${(_verification['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                )),
                            Expanded(child: _infoItem(Icons.calendar_today, 'Submitted',
                                _verification['submittedDate'] as String)),
                          ],
                        ),
                        const Divider(height: 16),
                        _infoItem(Icons.gps_fixed, 'Purpose', _verification['purpose'] as String, fullWidth: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Photo
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.image_outlined, size: 20, color: AppTheme.gray600),
                            SizedBox(width: 8),
                            Text('Uploaded Photo',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _verification['imageUrl'] as String,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              color: AppTheme.gray100,
                              child: const Center(child: Icon(Icons.broken_image, size: 60, color: AppTheme.gray400)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metadata
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Metadata',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: AppTheme.blue600),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('GPS Location', style: TextStyle(fontSize: 11, color: AppTheme.gray600)),
                                        Text(_verification['location'] as String,
                                            style: const TextStyle(fontSize: 13, color: AppTheme.gray800)),
                                        Text(_verification['locationName'] as String,
                                            style: const TextStyle(fontSize: 11, color: AppTheme.gray600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                child: const Text('View on Map →',
                                    style: TextStyle(fontSize: 12, color: AppTheme.blue600)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: AppTheme.green600),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Timestamp', style: TextStyle(fontSize: 11, color: AppTheme.gray600)),
                                  Text(_verification['timestamp'] as String,
                                      style: const TextStyle(fontSize: 13, color: AppTheme.gray800)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Asset Description',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                        const SizedBox(height: 16),
                        Text(_verification['description'] as String,
                            style: const TextStyle(fontSize: 13, color: AppTheme.gray700, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // AI Validation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFAF5FF), Color(0xFFEFF6FF)],
                      ),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.bolt, size: 20, color: Color(0xFF9333EA)),
                                SizedBox(width: 6),
                                Text('AI Validation',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: confidenceBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('$confidence% Confidence',
                                  style: TextStyle(fontSize: 13, color: confidenceColor, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        for (final check in aiChecks)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    check['passed'] as bool ? Icons.check_circle : Icons.cancel,
                                    size: 16,
                                    color: check['passed'] as bool ? AppTheme.green600 : AppTheme.red600,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(check['check'] as String,
                                        style: const TextStyle(fontSize: 13, color: AppTheme.gray700)),
                                  ),
                                  Text(check['result'] as String,
                                      style: const TextStyle(fontSize: 11, color: AppTheme.gray500)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Remarks
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Officer Remarks',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _remarksController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add your verification remarks here (optional)...',
                            hintStyle: const TextStyle(fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.gray200, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.green500, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppGradients.greenHeader,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppTheme.green600.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAction('approve'),
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text('Approve Submission', style: TextStyle(color: Colors.white)),
                      style: AppTheme.elevatedOnGradient(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAction('request-resubmit'),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Request Resubmission', style: TextStyle(color: Colors.white)),
                      style: AppTheme.elevatedSolid(AppTheme.amber600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _handleAction('reject'),
                      icon: const Icon(Icons.cancel, color: AppTheme.red600),
                      label: const Text('Reject Submission', style: TextStyle(color: AppTheme.red600)),
                      style: AppTheme.outlinedFullWidth(
                        sideColor: AppTheme.red600,
                        foregroundColor: AppTheme.red600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _infoItem(IconData icon, String label, String value, {bool fullWidth = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.gray400),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.gray500)),
              const SizedBox(height: 16),
              Text(value, style: const TextStyle(fontSize: 13, color: AppTheme.gray800)),
            ],
          ),
        ),
      ],
    );
  }
}
