import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_role.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import 'team_role_state.dart';

class TeamRoleCubit extends Cubit<TeamRoleState> {
  TeamRoleCubit({required this.api}) : super(TeamRoleInitial());
  static TeamRoleCubit get(context) => BlocProvider.of(context);

  DioConsumer api;

  Future<void> getAllTeamRoles() async {
    emit(TeamRoleLoading());
    try {
      final response = await api.get(ApiLink.getAllTeamRoles);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      List<dynamic> teamsRoleJson = response["data"];
      List<TeamRole> teamRolesObjects = teamsRoleJson
          .map((e) => TeamRole.fromJson(e))
          .toList();
      if (teamRolesObjects.isEmpty) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "لا توجد فرق ",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      emit(TeamRoleLoaded(teamRolesObjects));
    } on Serverexception catch (e) {
      emit(TeamRoleFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamRoleFailure(errorMessage: e.toString()));
    }
  }

}