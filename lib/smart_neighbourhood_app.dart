import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/cubits/blockCubit/block_cubit.dart';

import 'core/config/generated/l10n.dart';
import 'core/constants/app_color.dart';
import 'core/constants/app_route.dart';
import 'core/services/API/dio_consumer.dart';

class SmartNeighbourhoodApp extends StatelessWidget {
  const SmartNeighbourhoodApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlockCubit(api: DioConsumer(dio: Dio())),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        locale: const Locale('ar'),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.white,
          fontFamily: 'Tajawal-Regular',
        ),
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: initialRoute,
      ),
    );
  }
}
