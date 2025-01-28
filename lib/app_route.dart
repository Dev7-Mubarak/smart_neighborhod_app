import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/models/Block.dart';
import 'package:smart_neighborhod_app/views/residential_block_detial.dart';
import 'package:smart_neighborhod_app/views/login.dart';
import 'package:smart_neighborhod_app/views/mainhome.dart';
import 'package:smart_neighborhod_app/views/onboarding.dart';
import 'components/constants/app_route.dart';
import 'core/API/dio_consumer.dart';
import 'cubits/ResiddentialBlocksDetail_cubit/residdential_blocksdential_cubit.dart';

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
        return MaterialPageRoute(builder: (_) => const MainHome());

      case AppRoute.residentialBlockDetial:
        // final Block block = settings.arguments as Block; // تمرير معرّف العنصر
        return MaterialPageRoute(
            builder: (_) =>  BlocProvider(
            create: (BuildContext contxt) => ResiddentialBlockDetailCubit(api: DioConsumer(dio: Dio())),
            child:ResiddentialBlocksDetail(),
          ));

      default:
        return null; // في حالة وجود مسار غير معروف
    }
  }
}
