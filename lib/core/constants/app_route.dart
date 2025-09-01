import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/services/API/dio_consumer.dart';
import 'package:smart_negborhood_app/features/auth/cubits/forgetapassword/forgetapassword_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflictType/conflict_type_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_catgory_cubit/family_catgory_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_member/family_member_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/member_family_role_cubit/member_family_role_cubit.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/features/people/cubits/project_category/project_category_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_member/team_member_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_role/team_role_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import 'package:smart_negborhood_app/features/Assistances/presentation/views/add_family_to_assistanc.dart';
import 'package:smart_negborhood_app/features/Assistances/presentation/views/add_team_to_assistanc.dart';
import 'package:smart_negborhood_app/features/Assistances/presentation/views/add_update_assistanc.dart';
import 'package:smart_negborhood_app/features/Assistances/presentation/views/all_assistances.dart';
import 'package:smart_negborhood_app/features/Assistances/presentation/views/assistance_detiles.dart';
import 'package:smart_negborhood_app/features/annoucements/presentation/views/addNewAnnouncement.dart';
import 'package:smart_negborhood_app/features/annoucements/presentation/views/annoucement1.dart';
import 'package:smart_negborhood_app/features/auth/presentation/views/checkEmail.dart';
import 'package:smart_negborhood_app/features/auth/presentation/views/createNewPassword.dart';
import 'package:smart_negborhood_app/features/auth/presentation/views/forgetapassword.dart';
import 'package:smart_negborhood_app/features/auth/presentation/views/login.dart';
import 'package:smart_negborhood_app/features/home/presentation/views/mainhome.dart';
import 'package:smart_negborhood_app/features/confilct/presentation/views/add_update_conflict.dart';
import 'package:smart_negborhood_app/features/confilct/presentation/views/all_confilcts.dart';
import 'package:smart_negborhood_app/features/confilct/presentation/views/conflict_detiles.dart';
import 'package:smart_negborhood_app/features/families/presentation/views/add_update_family.dart';
import 'package:smart_negborhood_app/features/families/presentation/views/add_family_member.dart';
import 'package:smart_negborhood_app/features/families/presentation/views/family_detiles.dart';
import 'package:smart_negborhood_app/features/onBoarding/presentation/views/onboarding.dart';
import 'package:smart_negborhood_app/features/people/presentation/views/add_update_person.dart';
import 'package:smart_negborhood_app/features/people/presentation/views/all_pepole.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/presentation/views/add_update_block.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/presentation/views/residential_block_detial.dart';
import 'package:smart_negborhood_app/features/teams/presentation/views/add_update_team.dart';
import 'package:smart_negborhood_app/features/teams/presentation/views/add_update_team_member.dart';
import 'package:smart_negborhood_app/features/teams/presentation/views/all_teams.dart';
import 'package:smart_negborhood_app/features/teams/presentation/views/team_details.dart';
import '../../features/residdentailBlocks/cubits/cubit/block_cubit.dart';
import '../../features/Assistances/cubits/assistances/assistances_cubit.dart';
import '../../features/families/cubits/family_cubit/family_cubit.dart';
import '../../features/home/cubits/mainHome_cubit/main_home_cubit.dart';

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
          builder: (_) => BlocProvider<ForgetapasswordCubit>(
            create: (context) =>
                ForgetapasswordCubit(api: DioConsumer(dio: Dio())),
            child: Forgetapassword(),
          ),
          fullscreenDialog: false,
        );

      case AppRoute.checkEmail:
        final forgetapasswordCubit = settings.arguments as ForgetapasswordCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: forgetapasswordCubit,
            child: CheckEmail(),
          ),
          fullscreenDialog: false,
        );
      case AppRoute.createNewPassword:
        final forgetapasswordCubit = settings.arguments as ForgetapasswordCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: forgetapasswordCubit,
            child: CreateNewPassword(),
          ),
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
          builder: (_) => BlocProvider.value(
            value: assistancCubit,
            child: AssistanceDetiles(project: assistancCubit.project!),
          ),
        );
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

      case AppRoute.addFamilyToAssistance:
        final assistancCubit = settings.arguments as AssistancesCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<FamilyCubit>(
                create: (context) => FamilyCubit(
                  assistancCubit.blockId!,
                  api: DioConsumer(dio: Dio()),
                ),
              ),
              BlocProvider.value(value: assistancCubit),
            ],
            child: AddFamilyToAssistance(),
          ),
        );
      case AppRoute.addTeamsToAssistance:
        final assistancCubit = settings.arguments as AssistancesCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<TeamCubit>(
                create: (context) => TeamCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider.value(value: assistancCubit),
            ],
            child: AddTeamsToAssistance(),
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
          builder: (_) => BlocProvider<TeamCubit>(
            create: ((BuildContext context) =>
                TeamCubit(api: DioConsumer(dio: Dio()))),
            child: TeamDetails(team: team),
          ),
        );
      case AppRoute.allConflict:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ConflictCubit>(
            create: ((BuildContext context) =>
                ConflictCubit(api: DioConsumer(dio: Dio()))),
            child: const AllConflict(),
          ),
          fullscreenDialog: false,
        );
      case AppRoute.addUpdateConflict:
        final conflictCubit = settings.arguments as ConflictCubit;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<FamilyMemberCubit>(
                create: (context) =>
                    FamilyMemberCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider<ConflictTypeCubit>(
                create: (context) =>
                    ConflictTypeCubit(api: DioConsumer(dio: Dio())),
              ),
              BlocProvider.value(value: conflictCubit),
            ],
            child: AddUpdateConflict(conflict: conflictCubit.conflict),
          ),
        );
      case AppRoute.conflictDetiles:
        final conflict = settings.arguments as Conflict;

        return MaterialPageRoute(
          builder: (_) => ConflictDetiles(conflict: conflict),
        );
      default:
        return null;
    }
  }
}

class AppRoute {
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String mainHome = '/mainhome';
  static const String residentialBlockDetial = '/ResidentialBlockDetial';
  static const String residentialBlocks = '/ResidentialBlock';
  static const String forgetapassword = '/forgetapassword';
  static const String checkEmail = '/CheckEmail';
  static const String createNewPassword = '/createNewPassword';
  static const String addUpdateBlock = '/AddUpdateBlock';
  static const String familyDetiles = '/FamilyDetiles';
  static const String addUpdateFamily = '/AddUpdateFamily';
  static const String addFamilyMember = '/AddFamilyMember';
  static const String addUpdatePerson = '/AddUpdatePerson';
  static const String arofilePage = '/ProfilePage';
  static const String allPeople = '/AllPeople';
  static const String allAssistances = '/AllAssistances';
  static const String addTeamsToAssistance = '/AddTeamsToAssistance';
  static const String addFamilyToAssistance = '/AddFamilyToAssistance';
  static const String allConflict = '/AllConflict';
  static const String addUpdateAssistanc = '/AddUpdateAssistanc';
  static const String assistanceDetiles = '/AssistanceDetiles';
  static const String allTeams = '/AllTeams';
  static const String teamDetails = '/TeamDetails';
  static const String addUpdateTeam = '/AddUpdateTeam';
  static const String reconciliationCouncilsScreen =
      '/ReconciliationCouncilsScreen';

  static const String annoucement1 = '/annoucement1';
  static const String addNewAnnouncement = '/addNewAnnouncement';
  static const String reconciliationCouncilDetials =
      '/Reconciliation_council_Detials';
  static const String addUpdateTeamMember = '/AddUpdateTeamMember';
  static const String addUpdateConflict = '/AddUpdateConflict';
  static const String conflictDetiles = '/ConflictDetiles';
  static const String familyMemberDetails = '/FamilyMemberDetails';
}
