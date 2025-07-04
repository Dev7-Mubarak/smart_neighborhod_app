import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import '../../components/category_card.dart';
import '../../components/constants/app_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<CategoryCard> categoryCardList = [
      CategoryCard(
        title: 'جميع الأفراد',
        imagePath: AppImage.homecomplan,
        backgroundColor: const Color(0xFF5B27D5),
        onTap: () {
          Navigator.pushNamed(context, AppRoute.allPeople);
        },
      ),
      CategoryCard(
        title: 'كشف عام للوحدة',
        imagePath: AppImage.homeresidential,
        backgroundColor: const Color(0xFFEFA98D),
        onTap: () {
          // Navigator.pushNamed(context, AppRoute.residentialBlocks);
        },
      ),
      CategoryCard(
        title: 'قسم المساعدات',
        imagePath: AppImage.homehelping,
        backgroundColor: const Color(0xFFE8618C),
        onTap: () {
          Navigator.pushNamed(context, AppRoute.allAssistances);
        },
      ),
      CategoryCard(
        title: 'قسم التعهدات',
        imagePath: AppImage.homehonesty,
        backgroundColor: const Color(0xFF237885),
        onTap: () {},
      ),
      CategoryCard(
        title: 'قسم الإتفاقات',
        imagePath: AppImage.homehandshake,
        backgroundColor: const Color(0xFF125D95),
        onTap: () {},
      ),

      CategoryCard(
        title: 'خطط الأزمات',
        imagePath: AppImage.homeplan,
        backgroundColor: const Color(0xFF545CEA),
        onTap: () {},
      ),
      CategoryCard(
        title: 'قسم الأمن',
        imagePath: AppImage.homepoliceman,
        backgroundColor: const Color(0xFF22CCB2),
        onTap: () {},
      ),
      CategoryCard(
        title: 'قسم المناشدات',
        imagePath: AppImage.monashadatimage,
        backgroundColor: const Color(0xFF878CED),
        onTap: () {},
      ),
      CategoryCard(
        title: 'جلسات الصلح',
        imagePath: AppImage.homecomplan,
        backgroundColor: const Color(0xFF5B27D5),
        onTap: () {},
      ),
      CategoryCard(
        title: 'قسم الفرق',
        imagePath: AppImage.team,
        backgroundColor: const Color(0xFFE8618C),
        onTap: () {
                    Navigator.pushNamed(context, AppRoute.allTeams);
        },
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: categoryCardList,
            ),
          ],
        ),
      ),
    );
  }
}
