import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'beneficiary_details_screen.dart';
import 'view_officers_screen.dart';

/// Shows a flat list of all beneficiaries from all officers.
/// Each beneficiary card is tappable to view full details.
class ViewBeneficiariesScreen extends StatelessWidget {
  const ViewBeneficiariesScreen({super.key});

  List<Map<String, dynamic>> get _allBeneficiaries {
    final List<Map<String, dynamic>> all = [];
    for (final officer in ViewOfficersScreen.officers) {
      final beneficiaries = officer['beneficiaries'] as List<Map<String, dynamic>>;
      for (final b in beneficiaries) {
        all.add({...b, 'officerName': officer['name']});
      }
    }
    return all;
  }

  String _formatAmount(int amt) {
    return amt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final beneficiaries = _allBeneficiaries;

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
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 28),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.group, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('All Beneficiaries', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        Text('${beneficiaries.length} records', style: TextStyle(color: Colors.blue[100], fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: beneficiaries.length,
              itemBuilder: (context, index) {
                final b = beneficiaries[index];
                final isApproved = b['loanStatus'] == 'approved';
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BeneficiaryDetailsScreen(beneficiary: b)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.person, size: 24, color: AppTheme.blue600),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.gray800)),
                              const SizedBox(height: 2),
                              Text(b['loanId'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.gray500)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '₹${_formatAmount(b['loanAmount'] as int)}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray700),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isApproved ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      isApproved ? 'Approved' : 'Pending',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isApproved ? AppTheme.green600 : AppTheme.amber600),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    b['officerName'] as String,
                                    style: const TextStyle(fontSize: 10, color: AppTheme.gray400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: AppTheme.gray400),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
