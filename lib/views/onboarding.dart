import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_image.dart';
import 'package:smart_neighborhod_app/components/constants/app_route.dart';
import 'package:smart_neighborhod_app/views/login.dart';
import '../components/constants/app_color.dart';
import '../components/defult_button.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.primaryColor,
        child: Column(
          children: [
            const Image(image: AssetImage(AppImage.onBoardingImage)),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Image(image: AssetImage(AppImage.logo)),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'الحارة الذكية',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,

                        // fontWeight: FontWeight.w400,
                        // fontFamily: 'Tajawal',
                        height: 26 / 40,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'أدواتك لتنظيم الحي\nوالمربعات السكنية بكفاءة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        // fontFamily: 'Tajawal',
                        height: 31 / 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DefaultButton(
                text: 'تسجيل الدخول',
                backgroundColor: AppColor.white,
                color: AppColor.primaryColor,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.login,
                  );
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>const Login(),
                  //   ),
                  //   (route) => false, // شرط لإزالة جميع الشاشات السابقة
                  // );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
