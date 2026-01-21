import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import '../../data/models/government_institution.dart';
import 'government_institution_state.dart';

class GovernmentInstitutionCubit extends Cubit<GovernmentInstitutionState> {
  GovernmentInstitutionCubit({required this.api})
    : super(GovernmentInstitutionInitial());
  static GovernmentInstitutionCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  List<GovernmentInstitution> _allGovernmentInstitutions = [];
  GovernmentInstitution? institution;

  void setInstitutionForUpdate(GovernmentInstitution institution) {
    this.institution = institution;
  }

  void resetInputs() {
    institution = null;
  }

  Future<void> getAllGovernmentInstitutions({String? search}) async {
    emit(GovernmentInstitutionLoading());
    try {
      final response = await api.get(
        ApiLink.getAllGovernmentInstitutions,
        treat404AsEmptyList: true,
      );

      List<dynamic> jsonList = response["data"];
      _allGovernmentInstitutions = jsonList
          .map((e) => GovernmentInstitution.fromJson(e))
          .toList();

      if (search != null && search.isNotEmpty) {
        filterGovernmentInstitutions(search);
      } else {
        emit(
          GovernmentInstitutionLoaded(
            allGovernmentInstitutions: _allGovernmentInstitutions,
            filteredGovernmentInstitutions: _allGovernmentInstitutions,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(GovernmentInstitutionFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(GovernmentInstitutionFailure(errorMessage: e.toString()));
    }
  }

  void filterGovernmentInstitutions(String query) {
    if (query.isEmpty) {
      emit(
        GovernmentInstitutionLoaded(
          allGovernmentInstitutions: _allGovernmentInstitutions,
          filteredGovernmentInstitutions: _allGovernmentInstitutions,
        ),
      );
      return;
    }

    final filteredList = _allGovernmentInstitutions
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(
      GovernmentInstitutionLoaded(
        allGovernmentInstitutions: _allGovernmentInstitutions,
        filteredGovernmentInstitutions: filteredList,
      ),
    );
  }

  Future<void> addNewGovernmentInstitution(String name) async {
    emit(WaitAddedUpdatedGovernmentInstitution());
    try {
      final response = await api.post(
        ApiLink.addGovernmentInstitution,
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(
          GovernmentInstitutionAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
        await getAllGovernmentInstitutions();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(GovernmentInstitutionFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(GovernmentInstitutionFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateGovernmentInstitution({
    required int id,
    required String name,
  }) async {
    emit(WaitAddedUpdatedGovernmentInstitution());
    try {
      final response = await api.update(
        '${ApiLink.updateGovernmentInstitution}/$id',
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(
          GovernmentInstitutionUpdatedSuccessfully(
            message: response["data"] ?? "تم التحديث بنجاح",
          ),
        );
        await getAllGovernmentInstitutions();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"],
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(GovernmentInstitutionFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(GovernmentInstitutionFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteGovernmentInstitution(int id) async {
    emit(WaitDeleteGovernmentInstitution());
    try {
      final response = await api.delete(
        '${ApiLink.deleteGovernmentInstitution}/$id',
      );

      if (response["isSuccess"]) {
        emit(
          GovernmentInstitutionDeletedSuccessfully(
            message: response["data"] ?? "تم الحذف بنجاح",
          ),
        );
        await getAllGovernmentInstitutions();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"],
            errorMessage: response["message"],
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        DeleteGovernmentInstitutionFailure(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(DeleteGovernmentInstitutionFailure(errorMessage: e.toString()));
    }
  }
}
