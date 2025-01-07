import 'package:flutter/material.dart';

import '../components/CategoryCard.dart';
import '../components/constants/app_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة
    final screenWidth = MediaQuery.of(context).size.width;

    // تحديد عدد الأعمدة بناءً على عرض الشاشة
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // 3 أعمدة للشاشات الكبيرة و2 للصغيرة

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // مسافة خارجية حول العناصر
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(), // تعطيل التمرير داخل GridView لأننا نستخدم SingleChildScrollView
          shrinkWrap: true, // تقليل المساحة المستخدمة لتتناسب مع المحتوى
          crossAxisCount: crossAxisCount, // عدد الأعمدة حسب حجم الشاشة
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            CategoryCard(
              title: 'قسم الإعلانات',
              imagePath: AppImage.homeMicrovon,
              backgroundColor: Color(0xFF878CED),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'كشف عام للوحدة',
              imagePath: AppImage.homeresidential,
              backgroundColor: Color(0xFFEFA98D),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'قسم الاتفاقات',
              imagePath: AppImage.homehandshake,
              backgroundColor: Color(0xFF125D95),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'جلسات الصلح',
              imagePath: AppImage.homecomplan,
              backgroundColor: Color(0xFF5B27D5),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'قسم المساعدات',
              imagePath: AppImage.homehelping,
              backgroundColor: Color(0xFFE8618C),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'قسم التعهدات',
              imagePath: AppImage.homehonesty,
              backgroundColor: Color(0xFF237885),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'خطط الأزمات',
              imagePath: AppImage.homeplan,
              backgroundColor: Color(0xFF545CEA),
              onTap: () {
                // إجراء عند النقر
              },
            ),
            CategoryCard(
              title: 'قسم الأمن',
              imagePath: AppImage.homepoliceman,
              backgroundColor: Color(0xFF22CCB2),
              onTap: () {
                // إجراء عند النقر
              },
            ),
          ],
        ),
      ),
    );
  }
}
