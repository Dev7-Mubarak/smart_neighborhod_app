import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/views/ProfilePage.dart';
import 'package:smart_neighborhod_app/views/Reconciliation_council_Detials.dart';
import 'package:smart_neighborhod_app/views/Reconciliation_councils.dart';
import 'package:smart_neighborhod_app/views/addNewAnnouncement.dart';
import 'package:smart_neighborhod_app/views/addNewBlock.dart';
import 'package:smart_neighborhod_app/views/addNewFamily.dart';
import 'package:smart_neighborhod_app/views/add_new_person.dart';
import 'package:smart_neighborhod_app/views/all_pepole.dart';
import 'package:smart_neighborhod_app/views/annoucement1.dart';
import 'package:smart_neighborhod_app/views/checkEmail.dart';
import 'package:smart_neighborhod_app/views/createNewPassword.dart';
import 'package:smart_neighborhod_app/views/family_detiles.dart';
import 'package:smart_neighborhod_app/views/forgetapassword.dart';
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
      case AppRoute.allPeople:
        return MaterialPageRoute(
          builder: (_) => const AllPeople(),
        );

      case AppRoute.login:
        return MaterialPageRoute(
          builder: (_) => Login(),
        );

      case AppRoute.mainhome:
        return MaterialPageRoute(builder: (_) => const MainHome());

      case AppRoute.residentialBlockDetial:
      // final Block block = settings.arguments as Block; // تمرير معرّف العنصر
      // return MaterialPageRoute(
      //   builder: (_) => BlocProvider(
      //     create: (BuildContext contxt) =>
      //         ResiddentialBlockDetailCubit(api: DioConsumer(dio: Dio())),
      //     child: ResiddentialBlocksDetail(),
      //   ),
      // );

      case AppRoute.forgetapassword:
        return MaterialPageRoute(
          builder: (_) => forgetapassword(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );

      case AppRoute.checkEmail:
        return MaterialPageRoute(
          builder: (_) => checkEmail(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.createNewPassword:
        return MaterialPageRoute(
          builder: (_) => createNewPassword(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.AddNewBlock:
        return MaterialPageRoute(
          builder: (_) => AddNewBlock(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.FamilyDetiles:
        return MaterialPageRoute(
          builder: (_) => FamilyDetiles(familyId: 1044),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      // case AppRoute.AddNewFamily:
      //   return MaterialPageRoute(
      //     builder: (_) => AddNewFamily(),
      //     fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
      //   );
      case AppRoute.AddNewPerson:
        return MaterialPageRoute(
          builder: (_) => addNewPerson(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.ProfilePage:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      // case AppRoute.nnouncement:
      // return MaterialPageRoute(
      //   builder: (_) => announcement(),
      //   fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
      // );
      case AppRoute.annoucement1:
        return MaterialPageRoute(
          builder: (_) => announcement1(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.addNewAnnouncement:
        return MaterialPageRoute(
          builder: (_) => AddNewAnnouncement(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.ReconciliationCouncilsScreen:
        return MaterialPageRoute(
          builder: (_) => ReconciliationCouncilsScreen(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );
      case AppRoute.Reconciliation_council_Detials:
        return MaterialPageRoute(
          builder: (_) => ReconciliationcouncilDetials(),
          fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
        );

      default:
        return null; // في حالة وجود مسار غير معروف
    }
  }
}
