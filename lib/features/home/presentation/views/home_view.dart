import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_route.dart';
import '../../../../core/constants/home_tab_enum.dart';
import '../widgets/home_category_Card_list_widget.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  MmainHomeState createState() => MmainHomeState();
}

class MmainHomeState extends State<MainHome> {
  HomeTabEnum _selectedTab = HomeTabEnum.home;

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
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var locale = context.locale;
    final String username = "اسم المستخدم";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        bottomOpacity: 0,
        title: Row(
          children: [
            // Modern profile avatar with border and shadow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: AppColor.primaryColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.gray,
                child: const Icon(Icons.person, color: Colors.black, size: 26),
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
                  username,
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
