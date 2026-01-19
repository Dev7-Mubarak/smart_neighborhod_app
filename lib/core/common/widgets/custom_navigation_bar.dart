import 'package:flutter/material.dart';
import '../../constants/app_color.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColor.primaryColor,
            unselectedItemColor: const Color(0xFF565E6C),
            iconSize: 30,
            selectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            currentIndex: currentIndex,
            onTap: onTap,
            elevation: 0,
            items: [
              _buildNavItem(
                icon: Icons.home,
                label: 'الرئيسية',
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.apartment,
                label: 'الأحياء السكنية',
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.settings,
                label: 'الإعدادات',
                isActive: currentIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          icon,
          color: isActive ? AppColor.primaryColor : const Color(0xFF565E6C),
          size: isActive ? 34 : 28,
        ),
      ),
      label: label,
    );
  }
}
