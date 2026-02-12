import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'package:smart_negborhood_app/core/services/sync_service_locator.dart';
import 'package:smart_negborhood_app/core/config/injection.dart';
import 'core/config/app_Bloc_observer.dart';
import 'smart_neighbourhood_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  // Initialize dependency injection (database, API clients, etc.)
  await initializeDependencies();

  // Initialize sync services for offline-first architecture
  await SyncServiceLocator.init();

  Bloc.observer = AppBlocObserver();

  String initialRoute;
  if (!SharedPreferencesService.isOnboardingCompleted) {
    initialRoute = AppRoute.onBoarding;
  } else if (!SharedPreferencesService.isLoggedIn) {
    initialRoute = AppRoute.login;
  } else {
    initialRoute = AppRoute.mainHome;
  }

  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://a626d5df45d9e9dea0cb80dea84abffb@o4509708628525056.ingest.us.sentry.io/4510078787911680';
        options.sendDefaultPii = true;
      },
      appRunner: () => runApp(
        SmartNeighbourhoodApp(
          appRouter: AppRouter(),
          initialRoute: initialRoute,
        ),
      ),
    );
  } else {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => SmartNeighbourhoodApp(
          appRouter: AppRouter(),
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}
