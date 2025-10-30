import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/enums/app_role.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import '../../../../core/common/cubits/navigation_cubit.dart';
import '../../../../core/constants/app_image.dart';
import '../../../../core/services/shared_preferences_service.dart';
import 'category_card.dart';

class HomeCategoryCardListWidget extends StatefulWidget {
  const HomeCategoryCardListWidget({super.key});

  @override
  State<HomeCategoryCardListWidget> createState() =>
      _HomeCategoryCardListWidgetState();
}

class _HomeCategoryCardListWidgetState
    extends State<HomeCategoryCardListWidget> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // Read stored role (could be enum name or string). Normalize for comparison.
    final profileRole = SharedPreferencesService.getProfile()?.role;
    final roleString = profileRole?.toString() ?? '';
    final isAdmin =
        roleString.toLowerCase() == AppRole.Admin.name.toLowerCase();

    List<CategoryCard> categoryCardList = [
      if (isAdmin)
        CategoryCard(
          title: locale.allPeople,
          imagePath: AppImage.homecomplan,
          backgroundColor: const Color(0xFFE8618C),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.allPeople);
          },
        ),

      CategoryCard(
        title: "المربعات السكنية",
        imagePath: AppImage.homeresidential,
        backgroundColor: const Color(0xFFEFA98D),
        onTap: () => context.read<NavigationCubit>().changePage(1),
      ),
      CategoryCard(
        title: "قسم الاتفاقيات",
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
