import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import '../../data/models/residential_neighborhood_model.dart';
import 'residential_neighborhoods_state.dart';

class ResidentialNeighborhoodsCubit
    extends Cubit<ResidentialNeighborhoodsState> {
  ResidentialNeighborhoodsCubit({required this.api})
    : super(ResidentialNeighborhoodsInitial());
  static ResidentialNeighborhoodsCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  ResidentialNeighborhoodModel? residentialNeighborhood;
  int? selectedManager;

  Future<void> setResidentialNeighborhood(
    ResidentialNeighborhoodModel residentialNeighborhood,
  ) async {
    this.residentialNeighborhood = residentialNeighborhood;
    // this.selectedManager = residentialNeighborhood.personId;
  }

  void changeSelectedBlockManager(int? selectedBlockManager) {
    this.selectedManager = selectedBlockManager;
  }

  void changeResidentialNeighborhoodManager({
    required int id,
    required int personId,
    required String email,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.update(
        '${ApiLink.changeBlockManager}/$id/manager',
        data: {"email": email, "password": password, "personId": personId},
      );

      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodUpdatedSuccessfully(
            message: response["message"],
          ),
        );
        await getResidentialNeighborhoods();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getResidentialNeighborhoods() async {
    emit(ResidentialNeighborhoodsLoading());
    try {
      final response = await api.get(ApiLink.getAllResidentialNeighborhoods);

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> blocks = response["data"];

      emit(
        ResidentialNeighborhoodsLoaded(
          blocks.map((e) => ResidentialNeighborhoodModel.fromJson(e)).toList(),
        ),
      );
    } on Serverexception catch (e) {
      emit(
        ResidentialNeighborhoodsFailure(errorMessage: e.errModel.errorMessage),
      );
    } catch (e) {
      emit(ResidentialNeighborhoodsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addNewBlock(String name, String email, String password) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.post(
        ApiLink.addBlocke,
        data: {
          'name': name,
          'personId': selectedManager,
          'email': email,
          'password': password,
        },
      );

      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
        await getResidentialNeighborhoods();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateBlock({required int id, required String name}) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.update(
        '${ApiLink.updateBlocke}/$id',
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodUpdatedSuccessfully(
            message: response["message"],
          ),
        );
        await getResidentialNeighborhoods();
      } else {
        final String errorMessage =
            response["message"] ?? "حدث خطأ غير معروف أثناء تحديث البلوك";
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"],
            errorMessage: errorMessage,
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteResidentialNeighborhood(int id) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.delete(
        '${ApiLink.deleteResidentialNeighborhood}/$id',
      );

      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodDeletedSuccessfully(
            message: response["message"] ?? 'تم الحذف بنجاح',
          ),
        );
        await getResidentialNeighborhoods();
      } else {
        Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"],
            errorMessage: response["message"],
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        FailureForUpdateOrAddResidentialNeighborhood(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
