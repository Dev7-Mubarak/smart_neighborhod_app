import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/api_link.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../core/errors/exception.dart';
import '../../models/family_type.dart';
import 'family_type_state.dart';

class FamilyTypeCubit extends Cubit<FamilyTypeState> {
  FamilyTypeCubit({required this.api}) : super(FamilyTypeInitial());
  static FamilyTypeCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getFamilyTypies() async {
    emit(FamilyTypeLoading());
    try {
      final response = await api.get(
        ApiLink.getAllFamilyTypes,
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel: ErrorModel(
                statusCode: '400',
                errorMessage: "No data received",
                isSuccess: response["isSuccess"] ?? false));
      }

      List<dynamic> familyTypes = response["data"];

      emit(FamilyTypeLoaded(
          familyTypes:
              familyTypes.map((e) => FamilyType.fromJson(e)).toList()));
    } on Serverexception catch (e) {
      emit(FamilyTypeFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyTypeFailure(errorMessage: e.toString()));
    }
  }
}
