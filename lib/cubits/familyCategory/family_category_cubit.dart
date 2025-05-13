import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/familyCategory/family_category_state.dart';
import 'package:smart_neighborhod_app/models/family_category.dart';
import '../../components/constants/api_link.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../core/errors/exception.dart';

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
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
      }

      List<dynamic> familyCategories = response["data"];

      emit(FamilyCategoryLoaded(
          familyCategories: familyCategories
              .map((e) => FamilyCategory.fromJson(e))
              .toList()));
    } on Serverexception catch (e) {
      emit(FamilyCategoryFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyCategoryFailure(errorMessage: e.toString()));
    }
  }
}
