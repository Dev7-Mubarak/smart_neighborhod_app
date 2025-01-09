import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/%D9%90AppRouter.dart';
import 'components/constants/app_route.dart';
import 'test.dart';
import 'views/mainhome.dart';
import 'views/onboarding.dart';

void main() {
  runApp(
    SmartNeighbourhood(
      appRouter: AppRouter(),
    ),
  );
}

class SmartNeighbourhood extends StatelessWidget {
  final AppRouter appRouter;
  const SmartNeighbourhood({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal-Regular',
      ),
       onGenerateRoute: appRouter.generateRoute,
      initialRoute:AppRoute.onBoarding, // البداية من شاشة تسجيل الدخول
    );
  }
}
