import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';

import '../components/category_card.dart';
import '../components/constants/app_image.dart';
import '../components/searcharea.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryCard> categoryCardList = [
    CategoryCard(
      title: 'قسم الإعلانات',
      imagePath: AppImage.homeMicrovon,
      backgroundColor: const Color(0xFF878CED),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'كشف عام للوحدة',
      imagePath: AppImage.homeresidential,
      backgroundColor: const Color(0xFFEFA98D),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'قسم الإتفاقات',
      imagePath: AppImage.homehandshake,
      backgroundColor: const Color(0xFF125D95),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'جلسات الصلح',
      imagePath: AppImage.homecomplan,
      backgroundColor: const Color(0xFF5B27D5),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'قسم المساعدات',
      imagePath: AppImage.homehelping,
      backgroundColor: const Color(0xFFE8618C),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'قسم التعهدات',
      imagePath: AppImage.homehonesty,
      backgroundColor: const Color(0xFF237885),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'خطط الأزمات',
      imagePath: AppImage.homeplan,
      backgroundColor: const Color(0xFF545CEA),
      onTap: () {
        // إجراء عند النقر
      },
    ),
    CategoryCard(
      title: 'قسم الأمن',
      imagePath: AppImage.homepoliceman,
      backgroundColor: const Color(0xFF22CCB2),
      onTap: () {
        // إجراء عند النقر
      },
    ),
     CategoryCard(
      title: 'قسم المناشدات',
      imagePath: AppImage.monashadatimage,
      backgroundColor: const Color(0xFF878CED),
      onTap: () {
        // إجراء عند النقر
      },
    ),
  ];

  List<CategoryCard> displayedCategoryList = []; // القائمة المعروضة



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // إضافة ودجت البحث
            SearchWidget<CategoryCard>(
              originalList: categoryCardList,
              onSearch: (filteredList) {
                setState(() {
                  displayedCategoryList = filteredList; // تحديث القائمة المعروضة
                });
              },
              searchCriteria: (category) => category.title, // البحث في العنوان
            ),
            const SizedBox(height: 10),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: displayedCategoryList,
            ),
          ],
        ),
      ),
    );
  }
}
