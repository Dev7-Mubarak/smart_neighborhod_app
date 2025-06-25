import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/constants/api_link.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../core/errors/exception.dart';
import '../../models/family_category.dart';
import 'family_catgory_state.dart';

class FamilyCategoryCubit extends Cubit<FamilyCategoryState> {
  FamilyCategoryCubit({required this.api}) : super(FamilyCategoryInitial());
  static FamilyCategoryCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getFamilyCategories() async {
    emit(FamilyCategoryLoading());
    try {
      final response = await api.get(
        ApiLink.getAllFamilyCategories,
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel: ErrorModel(
                statusCode: '400',
                errorMessage: "No data received",
                isSuccess: response["isSuccess"] ?? false));
      }

      List<dynamic> familyCatgories = response["data"];

      emit(FamilyCategoryLoaded(
          familyCategories:
              familyCatgories.map((e) => FamilyCategory.fromJson(e)).toList()));
    } on Serverexception catch (e) {
      emit(FamilyCategoryFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyCategoryFailure(errorMessage: e.toString()));
    }
  }
}
