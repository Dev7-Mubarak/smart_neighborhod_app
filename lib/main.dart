import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'core/config/app_Bloc_observer.dart';
import 'smart_neighbourhood_app.dart';

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
    SmartNeighbourhoodApp(appRouter: AppRouter(), initialRoute: initialRoute),
  );
}
