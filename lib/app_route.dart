import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/API/dio_consumer.dart';
import 'package:smart_negborhood_app/cubits/family_catgory_cubit/family_catgory_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_type/family_type_cubit.dart';
import 'package:smart_negborhood_app/cubits/member_family_role_cubit/member_family_role_cubit.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/cubits/project_category/project_category_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/cubits/team_member/team_member_cubit.dart';
import 'package:smart_negborhood_app/cubits/team_role/team_role_cubit.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/views/Assistances/add_update_assistanc.dart';
import 'package:smart_negborhood_app/views/Assistances/all_assistances.dart';
import 'package:smart_negborhood_app/views/Assistances/assistance_detiles.dart';
import 'package:smart_negborhood_app/views/annoucements/addNewAnnouncement.dart';
import 'package:smart_negborhood_app/views/annoucements/annoucement1.dart';
import 'package:smart_negborhood_app/views/auth/checkEmail.dart';
import 'package:smart_negborhood_app/views/auth/createNewPassword.dart';
import 'package:smart_negborhood_app/views/auth/forgetapassword.dart';
import 'package:smart_negborhood_app/views/auth/login.dart';
import 'package:smart_negborhood_app/views/base/mainhome.dart';
import 'package:smart_negborhood_app/views/families/add_update_family.dart';
import 'package:smart_negborhood_app/views/families/add_family_member.dart';
import 'package:smart_negborhood_app/views/families/family_detiles.dart';
import 'package:smart_negborhood_app/views/onBoarding/onboarding.dart';
import 'package:smart_negborhood_app/views/people/add_update_person.dart';
import 'package:smart_negborhood_app/views/people/all_pepole.dart';
import 'package:smart_negborhood_app/views/reconciliations/Reconciliation_council_Detials.dart';
import 'package:smart_negborhood_app/views/reconciliations/Reconciliation_councils.dart';
import 'package:smart_negborhood_app/views/residdentailBlocks/add_update_block.dart';
import 'package:smart_negborhood_app/views/residdentailBlocks/residential_block_detial.dart';
import 'package:smart_negborhood_app/views/teams/add_update_team.dart';
import 'package:smart_negborhood_app/views/teams/add_update_team_member.dart';
import 'package:smart_negborhood_app/views/teams/all_teams.dart';
import 'package:smart_negborhood_app/views/teams/team_details.dart';
import 'components/constants/app_route.dart';
import 'cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import 'cubits/assistances/assistances_cubit.dart';
import 'cubits/family_cubit/family_cubit.dart';
import 'cubits/mainHome_cubit/main_home_cubit.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.onBoarding:
        return MaterialPageRoute(builder: (_) => const Onboarding());
      case AppRoute.mainHome:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => MainHomeCubit()),
              BlocProvider(
                create: (_) => BlockCubit(api: DioConsumer(dio: Dio())),
              ),
            ],
            child: const MainHome(),
          ),
        );

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
            child: AddUpdatePerson(person: personCubit.person),
          ),
        );
      case AppRoute.addUpdateFamily:
        final familyCubit = settings.arguments as FamilyCubit;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: familyCubit),
              BlocProvider(
                create: (_) => PersonCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider(
                create: (_) =>
                    FamilyCategoryCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider(
                create: (_) => FamilyTypeCubit(api: DioConsumer(dio: Dio())),
              ),
            ],
            child: AddUpdateFamily(
              blockId: familyCubit.blockId,
              family: familyCubit.family,
            ),
          ),
        );

      case AppRoute.login:
        return MaterialPageRoute(builder: (_) => Login());

      case AppRoute.residentialBlockDetial:
        final blockId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<FamilyCubit>(
            create: (_) => FamilyCubit(blockId, api: DioConsumer(dio: Dio())),
            child: ResiddentialBlocksDetail(blockId: blockId),
          ),
        );

      case AppRoute.forgetapassword:
        return MaterialPageRoute(
          builder: (_) => forgetapassword(),
          fullscreenDialog: false,
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
      case AppRoute.addUpdateBlock:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<PersonCubit>(
            create: (context) => PersonCubit(api: DioConsumer(dio: Dio())),
            child: const AddUpdateBlock(),
          ),
          fullscreenDialog: false,
        );

      case AppRoute.familyDetiles:
        final familyCubit = settings.arguments as FamilyCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: familyCubit,
            child: FamilyDetiles(familyId: familyCubit.family!.id),
          ),
          fullscreenDialog: false,
        );
      case AppRoute.addFamilyMember:
        final familyCubit = settings.arguments as FamilyCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: familyCubit),
              BlocProvider(
                create: (_) => PersonCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider(
                create: (_) =>
                    MemberFamilyRoleCubit(api: DioConsumer(dio: Dio())),
              ),
            ],
            child: AddFamilyMember(familyId: familyCubit.family!.id),
          ),
        );
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
      case AppRoute.allAssistances:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: ((BuildContext context) =>
                AssistancesCubit(api: DioConsumer(dio: Dio()))),
            child: const AllAssistances(),
          ),
        );
      case AppRoute.addUpdateAssistanc:
        final assistancCubit = settings.arguments as AssistancesCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<PersonCubit>(
                create: (context) => PersonCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider<ProjectCategoryCubit>(
                create: (context) =>
                    ProjectCategoryCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider.value(
                value: assistancCubit,
                child: AddUpdateAssistanc(
                  assistancProject: assistancCubit.project,
                ),
              ),
            ],
            child: AddUpdateAssistanc(assistancProject: assistancCubit.project),
          ),
        );
      case AppRoute.assistanceDetiles:
        final assistancCubit = settings.arguments as AssistancesCubit;
        return MaterialPageRoute(
          builder: (_) => AssistanceDetiles(project: assistancCubit.project!),
          fullscreenDialog: false,
        );
      // final assistancCubit = settings.arguments as AssistancesCubit;
      // return MaterialPageRoute(
      //   builder: (_) => MultiBlocProvider(
      //     providers: [
      //       BlocProvider<PersonCubit>(
      //         create: (context) => PersonCubit(api: DioConsumer(dio: Dio())),
      //       ),
      //       BlocProvider<ProjectCategoryCubit>(
      //         create: (context) => ProjectCategoryCubit(api: DioConsumer(dio: Dio())),
      //       ),
      //       BlocProvider.value(
      //         value: assistancCubit,
      //         child: AddUpdateAssistanc(
      //           assistancProject: assistancCubit.project,
      //         ),
      //       ),
      //     ],
      //     child: AddUpdateAssistanc(
      //       assistancProject: assistancCubit.project,
      //     ),
      //   ),
      // );
      case AppRoute.allTeams:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<TeamCubit>(
                create: (context) => TeamCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider<TeamMemberCubit>(
                create: (context) =>
                    TeamMemberCubit(api: DioConsumer(dio: Dio())),
              ),
            ],
            child: AllTeams(),
          ),
        );
      case AppRoute.addUpdateTeam:
        final teamCubit = settings.arguments as TeamCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<PersonCubit>(
                create: (context) => PersonCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider.value(value: teamCubit),
            ],
            child: AddUpdateTeam(team: teamCubit.team),
          ),
        );
      case AppRoute.addUpdateTeamMember:
        final teamMemberCubit = settings.arguments as TeamMemberCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<PersonCubit>(
                create: (context) => PersonCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider<TeamRoleCubit>(
                create: (context) =>
                    TeamRoleCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider.value(value: teamMemberCubit),
            ],
            child: AddUpdateTeamMember(teamMember: teamMemberCubit.teamMember),
          ),
        );
      case AppRoute.teamDetails:
        final team = settings.arguments as Team;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<TeamCubit>(
                create: (context) => TeamCubit(api: DioConsumer(dio: Dio())),
              ),
            ],
            child: TeamDetails(team: team),
          ),
        );
      default:
        return null;
    }
  }
}
