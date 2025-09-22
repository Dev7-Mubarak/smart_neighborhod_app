import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_route.dart';
import 'home.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  MmainHomeState createState() => MmainHomeState();
}

class MmainHomeState extends State<MainHome> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    if (index == 1) {
      // Navigate to ResidentialBlock
      Navigator.pushReplacementNamed(context, AppRoute.residentialBlocks);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
                  username, // Replace with actual username variable
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
              icon: Icon(Icons.notifications),
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
        child: const Home(),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
