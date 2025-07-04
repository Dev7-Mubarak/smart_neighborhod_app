import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/app_route.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/core/API/dio_consumer.dart';
import 'package:smart_negborhood_app/services/cache_helper.dart';
import 'components/constants/app_route.dart';
import 'cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Bloc.observer = AppBlocObserver();
  runApp(SmartNeighbourhood(appRouter: AppRouter()));
}

class SmartNeighbourhood extends StatelessWidget {
  const SmartNeighbourhood({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlockCubit>(
      create: (_) => BlockCubit(api: DioConsumer(dio: Dio())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.white,
          fontFamily: 'Tajawal-Regular',
        ),
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: AppRoute.mainHome,
      ),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('Event: ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('State Change: ${bloc.runtimeType}, $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('Transition: ${bloc.runtimeType}, $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('Error: ${bloc.runtimeType}, $error');
  }
}
