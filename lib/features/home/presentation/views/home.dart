import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import '../../../../core/common/widgets/category_card.dart';
import '../../../../core/constants/app_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    List<CategoryCard> categoryCardList = [
      CategoryCard(
        title: locale.allPeople,
        imagePath: AppImage.homecomplan,
        backgroundColor: const Color(0xFF5B27D5),
        onTap: () {
          Navigator.pushNamed(context, AppRoute.allPeople);
        },
      ),
      CategoryCard(
        title: locale.generalUnitReport,
        imagePath: AppImage.homeresidential,
        backgroundColor: const Color(0xFFEFA98D),
        onTap: () {
          // Navigator.pushNamed(context, AppRoute.residentialBlocks);
        },
      ),
      CategoryCard(
        title: locale.conflictSection,
        imagePath: AppImage.homehandshake,
        backgroundColor: const Color(0xFF878CED),
        onTap: () {
          Navigator.pushNamed(context, AppRoute.allConflict);
        },
      ),
        CategoryCard(
        title: locale.assistanceSection,
        imagePath: AppImage.homehelping,
        backgroundColor: const Color(0xFFE8618C),
        onTap: () {
          Navigator.pushNamed(context, AppRoute.allAssistances);
        },
      ),
      CategoryCard(
        title: locale.teamsSection,
        imagePath: AppImage.team,
        backgroundColor: const Color(0xFF237885),
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
