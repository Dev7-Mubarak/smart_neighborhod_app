import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import '../../data/models/government_institution_contact.dart';
import 'government_institution_contact_state.dart';

class GovernmentInstitutionContactCubit
    extends Cubit<GovernmentInstitutionContactState> {
  GovernmentInstitutionContactCubit({required this.api})
    : super(GovernmentInstitutionContactInitial());
  static GovernmentInstitutionContactCubit get(context) =>
      BlocProvider.of(context);

  DioConsumer api;
  GovernmentInstitutionContact? contact;
  int? governmentInstitutionId;

  void setGovernmentInstitutionId(int id) {
    governmentInstitutionId = id;
  }

  void setContactForUpdate(GovernmentInstitutionContact contact) {
    this.contact = contact;
    governmentInstitutionId = contact.governmentInstitutionId;
  }

  void resetInputs() {
    contact = null;
  }

  Future<void> addGovernmentInstitutionContact({
    required String name,
    required String job,
    required String phone,
  }) async {
    emit(WaitAddedUpdatedGovernmentInstitutionContact());
    try {
      final response = await api.post(
        '${ApiLink.addGovernmentInstitutionContact}/$governmentInstitutionId',
        data: {'name': name, 'job': job, 'phone': phone},
      );
      if (response["isSuccess"]) {
        emit(
          GovernmentInstitutionContactAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
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
      emit(
        GovernmentInstitutionContactFailure(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(GovernmentInstitutionContactFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateGovernmentInstitutionContact({
    required int id,
    required String name,
    required String job,
    required String phone,
  }) async {
    emit(WaitAddedUpdatedGovernmentInstitutionContact());
    try {
      final response = await api.update(
        '${ApiLink.updateGovernmentInstitutionContact}/$id',
        data: {'name': name, 'job': job, 'phone': phone},
      );
      if (response["isSuccess"]) {
        emit(
          GovernmentInstitutionContactUpdatedSuccessfully(
            message: response["message"] ?? "تم التحديث بنجاح",
          ),
        );
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
      emit(
        GovernmentInstitutionContactFailure(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(GovernmentInstitutionContactFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteGovernmentInstitutionContact(int id) async {
    emit(WaitDeleteGovernmentInstitutionContact());
    try {
      final response = await api.delete(
        '${ApiLink.deleteGovernmentInstitutionContact}/$id',
      );

      if (response["isSuccess"]) {
        emit(
          GovernmentInstitutionContactDeletedSuccessfully(
            message: response["message"] ?? "تم الحذف بنجاح",
          ),
        );
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
        DeleteGovernmentInstitutionContactFailure(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        DeleteGovernmentInstitutionContactFailure(errorMessage: e.toString()),
      );
    }
  }
}
