import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants/app_color.dart';

class navigationBar extends StatelessWidget {
  const navigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
              textDirection: TextDirection.rtl,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColor.primaryColor,
                unselectedItemColor: const Color(0xFF565E6C),
                iconSize: 30, // زيادة حجم الأيقونات
                selectedLabelStyle: const TextStyle(
                  fontSize: 16, // تكبير حجم النص للعناصر المحددة
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14, // تكبير حجم النص للعناصر غير المحددة
                ),
                currentIndex: 0,
                onTap: (int j) {},
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'بحث',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'الإشعارات',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz),
                    label: 'أكثر',
                  ),
                ],
              ),
            );
  }
}
