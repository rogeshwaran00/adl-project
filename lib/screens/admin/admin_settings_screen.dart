import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = [
      {'title': 'Notifications', 'description': 'Alerts and reminders', 'icon': Icons.notifications_outlined},
      {'title': 'Security', 'description': 'Access and permissions', 'icon': Icons.shield_outlined},
      {'title': 'Data Management', 'description': 'Backup and retention', 'icon': Icons.storage_outlined},
    ];

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
                colors: [Color(0xFF374151), Color(0xFF4B5563)],
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
                      child: const Icon(Icons.settings, size: 24, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Tools', style: TextStyle(color: Colors.grey[300], fontSize: 11)),
                        const Text('System Settings',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: settings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = settings[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, size: 20, color: AppTheme.gray700),
                    ),
                    title: Text(item['title'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
                    subtitle: Text(item['description'] as String,
                        style: const TextStyle(fontSize: 12, color: AppTheme.gray500)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.gray400),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['title']} settings coming soon')),
                      );
                    },
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
