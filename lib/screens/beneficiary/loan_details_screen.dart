import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Full loan details view, navigated to from the Loan Summary card.
class LoanDetailsScreen extends StatelessWidget {
  final String loanId;
  final String name;
  final int amount;
  final String status;
  final String disbursedDate;
  final String purpose;
  final String deadline;
  final int progress;

  const LoanDetailsScreen({
    super.key,
    required this.loanId,
    required this.name,
    required this.amount,
    required this.status,
    required this.disbursedDate,
    required this.purpose,
    required this.deadline,
    required this.progress,
  });

  Color get _statusColor {
    switch (status) {
      case 'approved':
        return AppTheme.green600;
      case 'pending':
        return AppTheme.amber600;
      case 'rejected':
        return AppTheme.red600;
      default:
        return AppTheme.gray500;
    }
  }

  Color get _statusBg {
    switch (status) {
      case 'approved':
        return const Color(0xFFF0FDF4);
      case 'pending':
        return const Color(0xFFFFFBEB);
      case 'rejected':
        return const Color(0xFFFEF2F2);
      default:
        return AppTheme.gray100;
    }
  }

  String _formatAmount(int amt) {
    return amt.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 16,
              20,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text('Back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Loan Details',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                ),
                const SizedBox(height: 4),
                Text(loanId, style: TextStyle(color: Colors.blue[100], fontSize: 14)),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Amount Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.currency_rupee, size: 32, color: AppTheme.blue600),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '₹${_formatAmount(amount)}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.gray800),
                        ),
                        const SizedBox(height: 4),
                        const Text('Loan Amount', style: TextStyle(fontSize: 13, color: AppTheme.gray500)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _statusBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status[0].toUpperCase() + status.substring(1),
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _statusColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Loan Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.gray800)),
                        const SizedBox(height: 20),
                        _buildDetailRow(Icons.person, 'Beneficiary', name),
                        _divider(),
                        _buildDetailRow(Icons.badge, 'Loan ID', loanId),
                        _divider(),
                        _buildDetailRow(Icons.gps_fixed, 'Purpose', purpose),
                        _divider(),
                        _buildDetailRow(Icons.calendar_today, 'Disbursed', disbursedDate),
                        _divider(),
                        _buildDetailRow(Icons.event, 'Deadline', deadline),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Utilization Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.gray800)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$progress% Complete', style: const TextStyle(fontSize: 13, color: AppTheme.gray600)),
                            Text('${100 - progress}% Remaining', style: const TextStyle(fontSize: 13, color: AppTheme.gray400)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            minHeight: 10,
                            backgroundColor: AppTheme.gray200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 80 ? AppTheme.green600 : progress >= 50 ? AppTheme.blue600 : AppTheme.amber600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppTheme.blue600),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.gray500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(height: 1, color: AppTheme.gray100),
      );
}
