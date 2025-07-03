import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/models/member_family_role.dart';
import '../../components/constants/api_link.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../core/errors/exception.dart';
import 'member_family_role_state.dart';

class MemberFamilyRoleCubit extends Cubit<MemberFamilyRoleState> {
  MemberFamilyRoleCubit({required this.api}) : super(MemberFamilyRoleInitial());
  static MemberFamilyRoleCubit get(context) => BlocProvider.of(context);

  DioConsumer api;

  Future<void> fetchRoles() async {
    emit(MemberFamilyRoleLoading());
    try {
      final response = await api.get(ApiLink.getAllMemberFamilyRoles);

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> rolesList = response["data"];

      emit(
        MemberFamilyRoleLoaded(
          rolesList.map((e) => MemberFamilyRole.fromJson(e)).toList(),
        ),
      );
    } on Serverexception catch (e) {
      emit(MemberFamilyRoleFailure(e.errModel.errorMessage));
    } catch (e) {
      emit(MemberFamilyRoleFailure(e.toString()));
    }
  }
}
