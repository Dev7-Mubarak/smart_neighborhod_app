import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member2.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import 'family_member_state.dart';

class FamilyMemberCubit extends Cubit<FamilyMemberState> {
  FamilyMemberCubit({required this.api}) : super(FamilyMemberInitial());
  static FamilyMemberCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getFamilyMembers() async {
    emit(FamilyMemberLoading());
    try {
      final response = await api.get(ApiLink.getFamilyMembers);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> familyMembers = response["data"];

      emit(
        FamilyMemberLoaded(
          familyMembers: familyMembers
              .map((e) => FamilyMember2.fromJson(e))
              .toList(),
        ),
      );
    } on Serverexception catch (e) {
      emit(FamilyMemberFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyMemberFailure(errorMessage: e.toString()));
    }
  }
}
