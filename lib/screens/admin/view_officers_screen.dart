import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'officer_details_screen.dart';

/// Displays a list of all officers. Each officer card is tappable to view details.
class ViewOfficersScreen extends StatelessWidget {
  const ViewOfficersScreen({super.key});

  // Dummy officer data — shared structure so OfficerDetailsScreen can receive it
  static final List<Map<String, dynamic>> officers = [
    {
      'id': 'OFF-2026-042',
      'name': 'Priya Sharma',
      'role': 'Field Verification Officer',
      'phone': '+91 87654 32100',
      'email': 'priya.sharma@loandept.gov.in',
      'district': 'Jaipur',
      'assignedCount': 5,
      'beneficiaries': [
        {'name': 'Ramesh Kumar', 'mobile': '+91 98765 43210', 'address': '123, Green Valley, Jaipur', 'loanId': 'LN2026001234', 'loanAmount': 250000, 'loanStatus': 'pending', 'loanPurpose': 'Agricultural Equipment'},
        {'name': 'Sunita Devi', 'mobile': '+91 94321 67890', 'address': '45, Lake View, Ajmer', 'loanId': 'LN2026001189', 'loanAmount': 150000, 'loanStatus': 'approved', 'loanPurpose': 'Dairy Equipment'},
        {'name': 'Mohan Lal', 'mobile': '+91 99887 76655', 'address': '78, Station Rd, Jodhpur', 'loanId': 'LN2026001301', 'loanAmount': 100000, 'loanStatus': 'pending', 'loanPurpose': 'Fertilizers & Seeds'},
        {'name': 'Geeta Bai', 'mobile': '+91 91234 56789', 'address': '12, Temple St, Udaipur', 'loanId': 'LN2026001322', 'loanAmount': 200000, 'loanStatus': 'approved', 'loanPurpose': 'Irrigation System'},
        {'name': 'Karan Singh', 'mobile': '+91 93456 78901', 'address': '56, Hill Rd, Kota', 'loanId': 'LN2026001340', 'loanAmount': 180000, 'loanStatus': 'pending', 'loanPurpose': 'Warehouse Construction'},
      ],
    },
    {
      'id': 'OFF-2026-058',
      'name': 'Rajat Meena',
      'role': 'Senior Verification Officer',
      'phone': '+91 88776 65544',
      'email': 'rajat.meena@loandept.gov.in',
      'district': 'Udaipur',
      'assignedCount': 4,
      'beneficiaries': [
        {'name': 'Lakshmi Iyer', 'mobile': '+91 97654 32100', 'address': '90, MG Road, Udaipur', 'loanId': 'LN2026001102', 'loanAmount': 180000, 'loanStatus': 'approved', 'loanPurpose': 'Food Processing Unit'},
        {'name': 'Rajesh Sharma', 'mobile': '+91 96543 21098', 'address': '33, Civil Lines, Bhilwara', 'loanId': 'LN2026001156', 'loanAmount': 300000, 'loanStatus': 'pending', 'loanPurpose': 'Warehouse Construction'},
        {'name': 'Asha Kumari', 'mobile': '+91 95432 10987', 'address': '67, Gandhi Nagar, Chittor', 'loanId': 'LN2026001278', 'loanAmount': 120000, 'loanStatus': 'approved', 'loanPurpose': 'Handloom Equipment'},
        {'name': 'Vijay Patel', 'mobile': '+91 94321 09876', 'address': '21, Ring Rd, Banswara', 'loanId': 'LN2026001295', 'loanAmount': 220000, 'loanStatus': 'pending', 'loanPurpose': 'Poultry Farm Setup'},
      ],
    },
    {
      'id': 'OFF-2026-073',
      'name': 'Anita Gupta',
      'role': 'Field Verification Officer',
      'phone': '+91 87654 33221',
      'email': 'anita.gupta@loandept.gov.in',
      'district': 'Jodhpur',
      'assignedCount': 3,
      'beneficiaries': [
        {'name': 'Bharat Ram', 'mobile': '+91 93210 98765', 'address': '44, Paota, Jodhpur', 'loanId': 'LN2026001401', 'loanAmount': 175000, 'loanStatus': 'pending', 'loanPurpose': 'Solar Pump'},
        {'name': 'Devi Lal', 'mobile': '+91 92109 87654', 'address': '88, Mandore Rd, Jodhpur', 'loanId': 'LN2026001418', 'loanAmount': 90000, 'loanStatus': 'approved', 'loanPurpose': 'Cattle Purchase'},
        {'name': 'Kamla Devi', 'mobile': '+91 91098 76543', 'address': '15, Sojati Gate, Jodhpur', 'loanId': 'LN2026001430', 'loanAmount': 130000, 'loanStatus': 'pending', 'loanPurpose': 'Textile Shop'},
      ],
    },
  ];

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
                colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
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
                      child: const Icon(Icons.groups, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('All Officers', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        Text('${officers.length} officers registered', style: TextStyle(color: Colors.purple[100], fontSize: 13)),
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
              itemCount: officers.length,
              itemBuilder: (context, index) {
                final o = officers[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OfficerDetailsScreen(officer: o)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.manage_accounts, size: 28, color: Color(0xFF7C3AED)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.gray800)),
                              const SizedBox(height: 2),
                              Text(o['id'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.gray500)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.people_outline, size: 14, color: AppTheme.gray400),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${o['assignedCount']} beneficiaries assigned',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.gray600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${o['assignedCount']}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
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
