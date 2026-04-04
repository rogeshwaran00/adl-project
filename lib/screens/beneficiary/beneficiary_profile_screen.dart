import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Beneficiary profile screen — shows personal info and loan summary.
class BeneficiaryProfileScreen extends StatelessWidget {
  const BeneficiaryProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy beneficiary data
    const profile = {
      'name': 'Ramesh Kumar',
      'mobile': '+91 98765 43210',
      'address': '123, Green Valley, Sector 12, Jaipur, Rajasthan - 302001',
      'loanCount': '2',
      'email': 'ramesh.kumar@email.com',
      'aadhar': 'XXXX XXXX 4532',
    };

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
              36,
            ),
            child: Column(
              children: [
                // Back row
                Row(
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
                  ],
                ),
                const SizedBox(height: 24),
                // Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 44, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 14),
                Text(profile['name']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Beneficiary', style: TextStyle(color: Colors.blue[100], fontSize: 14)),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Info Card
                  _buildCard(
                    title: 'Personal Information',
                    children: [
                      _buildInfoTile(Icons.phone, 'Mobile', profile['mobile']!),
                      _buildInfoTile(Icons.email_outlined, 'Email', profile['email']!),
                      _buildInfoTile(Icons.location_on_outlined, 'Address', profile['address']!),
                      _buildInfoTile(Icons.credit_card, 'Aadhar', profile['aadhar']!),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Loan Stats
                  _buildCard(
                    title: 'Loan Summary',
                    children: [
                      _buildInfoTile(Icons.account_balance, 'Active Loans', profile['loanCount']!),
                      _buildInfoTile(Icons.currency_rupee, 'Total Amount', '₹4,30,000'),
                      _buildInfoTile(Icons.check_circle_outline, 'Repaid', '₹1,20,000'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Logout
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (_) => false),
                    style: AppTheme.outlinedFullWidth(sideColor: AppTheme.red600, foregroundColor: AppTheme.red600),
                    child: const Text('Logout'),
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

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.gray800)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: AppTheme.blue600),
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
}
