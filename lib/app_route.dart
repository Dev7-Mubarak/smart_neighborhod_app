import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/core/API/dio_consumer.dart';
import 'package:smart_neighborhod_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_neighborhod_app/views/annoucements/addNewAnnouncement.dart';
import 'package:smart_neighborhod_app/views/annoucements/annoucement1.dart';
import 'package:smart_neighborhod_app/views/auth/checkEmail.dart';
import 'package:smart_neighborhod_app/views/auth/createNewPassword.dart';
import 'package:smart_neighborhod_app/views/auth/forgetapassword.dart';
import 'package:smart_neighborhod_app/views/auth/login.dart';
import 'package:smart_neighborhod_app/views/base/mainhome.dart';
import 'package:smart_neighborhod_app/views/families/family_detiles.dart';
import 'package:smart_neighborhod_app/views/onBoarding/onboarding.dart';
import 'package:smart_neighborhod_app/views/people/add_update_person.dart';
import 'package:smart_neighborhod_app/views/people/all_pepole.dart';
import 'package:smart_neighborhod_app/views/reconciliations/Reconciliation_council_Detials.dart';
import 'package:smart_neighborhod_app/views/reconciliations/Reconciliation_councils.dart';
import 'package:smart_neighborhod_app/views/residdentailBlocks/addNewBlock.dart';
import 'components/constants/app_route.dart';
import 'cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import 'cubits/family_cubit/family_cubit.dart';
import 'cubits/mainHome_cubit/main_home_cubit.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.onBoarding:
        return MaterialPageRoute(
          builder: (_) => const Onboarding(),
        );
      case AppRoute.mainHome:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => MainHomeCubitCubit()),
              BlocProvider(
                  create: (_) => BlockCubit(api: DioConsumer(dio: Dio()))),
              BlocProvider(
                  create: (_) => FamilyCubit(api: DioConsumer(dio: Dio())))
            ],
            child: const MainHome(),
          ),
        );
      // return MaterialPageRoute(builder: (_) => const MainHome());

      case AppRoute.allPeople:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: ((BuildContext context) =>
                PersonCubit(api: DioConsumer(dio: Dio()))),
            child: const AllPeople(),
          ),
        );
      case AppRoute.addUpdatePerson:
        final personCubit = settings.arguments as PersonCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: personCubit,
            child: AddUpdatePerson(
              person: personCubit.person,
            ),
          ),
        );

      case AppRoute.login:
        return MaterialPageRoute(
          builder: (_) => Login(),
        );

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
          fullscreenDialog: false,
        );
      case AppRoute.createNewPassword:
        return MaterialPageRoute(
          builder: (_) => createNewPassword(),
          fullscreenDialog: false,
        );
      case AppRoute.addNewBlock:
        final blockCubit = settings.arguments as BlockCubit;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<PersonCubit>(
                create: (context) => PersonCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider.value(
                value: blockCubit,
                child: AddNewBlock(block: blockCubit.block),
              ),
            ],
            child: const AddNewBlock(),
          ),
          fullscreenDialog: false,
        );
      // case AppRoute.addNewBlock:
      //   return MaterialPageRoute(
      //     builder: (context) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider<PersonCubit>.value(
      //             value: context.read<PersonCubit>()),
      //         BlocProvider<BlockCubit>.value(
      //           value: context.read<BlockCubit>(),
      //         ),
      //       ],
      //       child: const AddNewBlock(),
      //     ),
      //     fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
      //   );
      //  return MaterialPageRoute(
      //   builder: (_) =>
      //   BlocProvider(
      //     create: (BuildContext contxt) =>
      //         BlockCubit(api: DioConsumer(dio: Dio())),
      //     child: AddNewBlock(),
      //   ),
      //   fullscreenDialog: false, // يجب أن يكون false حتى يظهر زر الرجوع
      // );
      /////////////////////////////////////////////////////////////////
      // return MaterialPageRoute(
      //   builder: (_) => const AddNewBlock(),
      //   fullscreenDialog: false,
      // );
      case AppRoute.familyDetiles:
        return MaterialPageRoute(
          builder: (_) => const FamilyDetiles(familyId: 1044),
          fullscreenDialog: false,
        );
      // case AppRoute.AddNewFamily:
      //   return MaterialPageRoute(
      //     builder: (_) => AddNewFamily(),
      //     fullscreenDialog: false,
      //   );
      // case AppRoute.nnouncement:
      // return MaterialPageRoute(
      //   builder: (_) => announcement(),
      //   fullscreenDialog: false,
      // );
      case AppRoute.annoucement1:
        return MaterialPageRoute(
          builder: (_) => announcement1(),
          fullscreenDialog: false,
        );
      case AppRoute.addNewAnnouncement:
        return MaterialPageRoute(
          builder: (_) => const AddNewAnnouncement(),
          fullscreenDialog: false,
        );
      case AppRoute.reconciliationCouncilsScreen:
        return MaterialPageRoute(
          builder: (_) => ReconciliationCouncilsScreen(),
          fullscreenDialog: false,
        );
      case AppRoute.reconciliationCouncilDetials:
        return MaterialPageRoute(
          builder: (_) => const ReconciliationcouncilDetials(),
          fullscreenDialog: false,
        );

      default:
        return null; // في حالة وجود مسار غير معروف
    }
  }
}
