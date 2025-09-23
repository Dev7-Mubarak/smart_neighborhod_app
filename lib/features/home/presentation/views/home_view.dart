import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_route.dart';
import '../../../../core/constants/home_tab_enum.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../widgets/home_category_Card_list_widget.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  MmainHomeState createState() => MmainHomeState();
}

class MmainHomeState extends State<MainHome> {
  HomeTabEnum _selectedTab = HomeTabEnum.home;
  late final ProfileModel? _profile;

  void _onNavBarTap(int index) {
    final tappedTab = HomeTabEnum.values[index];

    if (tappedTab == HomeTabEnum.residentialBlocks) {
      Navigator.pushReplacementNamed(context, AppRoute.residentialBlocks);
    } else if (tappedTab == HomeTabEnum.settings) {
      Navigator.pushReplacementNamed(context, AppRoute.settings);
    } else {
      setState(() {
        _selectedTab = tappedTab;
      });
    }
  }

  @override
  void initState() {
    _profile = SharedPreferencesService.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = context.locale;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        bottomOpacity: 0,
        title: Row(
          children: [
            // Modern profile avatar with border and shadow
            Container(
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.primaryColor,
                child: Text(
                  _profile?.email.isNotEmpty == true
                      ? _profile!.email[0].toUpperCase()
                      : '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Greeting and username with modern text style
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً,', // Or use locale.hello if localized
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  _profile?.email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.notifications_rounded,
                color: AppColor.primaryColor.withOpacity(0.9),
                size: 28,
              ),
              onPressed: () {},
              tooltip: 'الاشعارات',
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.white, AppColor.gray.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const HomeCategoryCardListWidget(),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedTab.index,
        onTap: _onNavBarTap,
      ),
    );
  }
}
