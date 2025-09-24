import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'core/config/app_Bloc_observer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  Bloc.observer = AppBlocObserver();

  String initialRoute;
  if (!SharedPreferencesService.isOnboardingCompleted) {
    initialRoute = AppRoute.onBoarding;
  } else if (!SharedPreferencesService.isLoggedIn) {
    initialRoute = AppRoute.login;
  } else {
    initialRoute = AppRoute.mainHome;
  }

  runApp(
    SmartNeighbourhood(appRouter: AppRouter(), initialRoute: initialRoute),
  );
}

class SmartNeighbourhood extends StatelessWidget {
  const SmartNeighbourhood({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
