import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';

import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_route.dart';
import '../../../../core/constants/home_tab_enum.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  HomeTabEnum _selectedTab = HomeTabEnum.settings;

  void _onNavBarTap(int index) {
    final tappedTab = HomeTabEnum.values[index];

    if (tappedTab == HomeTabEnum.residentialBlocks) {
      Navigator.pushReplacementNamed(context, AppRoute.residentialBlocks);
    } else if (tappedTab == HomeTabEnum.home) {
      Navigator.pushReplacementNamed(context, AppRoute.mainHome);
    } else {
      setState(() {
        _selectedTab = tappedTab;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            onTap: () {
              // Navigate to profile page
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('تغيير اللغة'),
            onTap: () {
              // Show language selection dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('تغيير كلمة المرور'),
            onTap: () {
              // Navigate to change password page
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedTab.index,
        onTap: _onNavBarTap,
      ),
    );
  }
}
