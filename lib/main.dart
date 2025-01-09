import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/cubits/login_cubit/login_cubit.dart';
import 'package:smart_neighborhod_app/cubits/login_cubit/login_state.dart';
import 'package:smart_neighborhod_app/services/dio_helper.dart';
import 'package:smart_neighborhod_app/views/login.dart';
import 'services/cache_helper.dart';
import 'test.dart';
import 'views/mainhome.dart';
import 'views/onboarding.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('Event: ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('State Change: ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('Transition: ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('Error: ${bloc.runtimeType}, $error');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  runApp(const SmartNeighbourhood());
}

class SmartNeighbourhood extends StatelessWidget {
  const SmartNeighbourhood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.white,
        fontFamily: 'Tajawal-Regular',
      ),
      home: Login(),
    );
  }
}
