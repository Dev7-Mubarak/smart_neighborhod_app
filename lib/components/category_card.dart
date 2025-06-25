import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath; // مسار الصورة
  final Color backgroundColor;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0), // مسافة داخلية للعنصر
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // الصورة مائلة إلى جهة اليمين
            Positioned(
              right: 0, // محاذاة الصورة إلى الجهة اليمنى
              top: 10, // إزاحة الصورة قليلاً نحو الأعلى
              child: Image.asset(
                imagePath,
                width: 80, // عرض الصورة
                height: 80, // ارتفاع الصورة
                fit: BoxFit.contain, // احتواء الصورة داخل الحجم
              ),
            ),
            // النص في الجهة اليسرى
            Positioned(
              left: 0, // محاذاة النص إلى الجهة اليسرى
              bottom: 10, // إزاحة النص قليلاً نحو الأسفل
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
