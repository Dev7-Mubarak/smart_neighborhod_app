import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';

import '../components/category_card.dart';
import '../components/constants/app_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryCard>? categoryCardListSearch;
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
      title: 'قسم الاتفاقات',
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
  ];

  final _searchTextController = TextEditingController();
  bool _isSearching = false;
  Widget _buildSearchField() {
    return Expanded(
      child: Container(
        height: 40, // التحكم في ارتفاع الحاوية الكاملة
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 244, 246),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0), // تقليل الحشو حول الحقل
          child: TextField(
            textAlign: TextAlign.right,
            controller: _searchTextController,
            cursorColor: AppColor.primaryColor,
            decoration: const InputDecoration(
              hintText: 'بحث',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 133, 134, 137),
                fontSize: 18,
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 5.0), // التحكم في ارتفاع النص داخل الحقل
            ),
            style: const TextStyle(color: Colors.black, fontSize: 18),
            onChanged: (searchedCategory) {
              addSearchedForItemsToSearchedList(searchedCategory);
            },
          ),
        ),
      ),
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCategory) {
    categoryCardListSearch = categoryCardList
        .where((category) => category.title
            .toLowerCase()
            .contains(searchedCategory.toLowerCase()))
        .toList();
    setState(() {});
  }

  Widget _buildAppBarActions() {
    return IconButton(
      onPressed: _isSearching ? _stopSearching : _startSearch,
      icon: Icon(
        _isSearching ? Icons.clear : Icons.search,
        color: Colors.black,
        size: 28,
      ),
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    setState(() {
      _searchTextController.clear();
      _isSearching = false;
      categoryCardListSearch = null; // لإلغاء الفلترة وإظهار القائمة الكاملة
    });
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة
    final screenWidth = MediaQuery.of(context).size.width;

    // تحديد عدد الأعمدة بناءً على عرض الشاشة
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    // القائمة التي ستُعرض (إما الفلترة أو القائمة الكاملة)
    final displayedList = categoryCardListSearch ?? categoryCardList;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isSearching) _buildSearchField(),
                _buildAppBarActions(),
              ],
            ),
            const SizedBox(height: 10),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: displayedList,
            ),
          ],
        ),
      ),
    );
  }
}
