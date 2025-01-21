import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/views/residential_block_detial.dart';
import 'package:smart_neighborhod_app/views/login.dart';
import 'package:smart_neighborhod_app/views/mainhome.dart';
import 'package:smart_neighborhod_app/views/onboarding.dart';
import 'components/constants/app_route.dart';

// تعريف AppRouter لإدارة التنقل بين الشاشات

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.onBoarding:
        return MaterialPageRoute(
          builder: (_) => const Onboarding(),
        );

      case AppRoute.login:
        return MaterialPageRoute(
          builder: (_) => Login(),
        );

      case AppRoute.mainhome:
        // final String itemId = settings.arguments as String; // تمرير معرّف العنصر
        return MaterialPageRoute(builder: (_) => const MainHome());

      case AppRoute.residentialBlockDetial:
        // final String itemId = settings.arguments as String; // تمرير معرّف العنصر
        return MaterialPageRoute(
            builder: (_) => const ResiddentialBlocksDetail());

      default:
        return null; // في حالة وجود مسار غير معروف
    }
  }
}
