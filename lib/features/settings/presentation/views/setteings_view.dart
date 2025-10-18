import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';

import '../../../../core/services/shared_preferences_service.dart';
import '../../../auth/data/models/login_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final ProfileModel? _profile;

  @override
  void initState() {
    _profile = SharedPreferencesService.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String email = _profile?.email ?? "S";
    final String defaultCover = email[0].toUpperCase();
    final String appVersion = "1.0.0";

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor.withOpacity(0.9),
                  AppColor.primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        defaultCover,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Email
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ======== MENU ITEMS ========
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'تغير كلمة المرور',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.forgetapassword);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications,
                  title: 'الأشعارات',
                  onTap: () {
                    // Show notifications settings
                  },
                ),
                _buildMenuItem(
                  icon: Icons.language,
                  title: 'تغيير اللغة',
                  onTap: () {
                    // Show language selection dialog
                  },
                ),
                _buildMenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'الشكاوي والاقتراحات',
                  onTap: () {
                    // Navigate to complaints and suggestions
                  },
                ),
                _buildMenuItem(
                  icon: Icons.share,
                  title: 'مشاركة التطبيق',
                  onTap: () {
                    // Share the app
                  },
                ),

                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  trailingWidget: Text(
                    "الإصدار $appVersion",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  onTap: () {
                    // Show about dialog
                  },
                ),

                const SizedBox(height: 20),

                // ======== LOGOUT BUTTON ========
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تأكيد تسجيل الخروج'),
                        content: const Text(
                          'هل أنت متأكد أنك تريد تسجيل الخروج من التطبيق؟',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      SharedPreferencesService.clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoute.login,
                        (route) => false,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailingWidget,
  }) {
    return ListTile(
      leading: const Icon(Icons.chevron_left, color: Colors.grey),
      trailing: trailingWidget ?? Icon(icon, color: AppColor.primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
