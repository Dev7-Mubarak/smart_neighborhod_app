import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_Dashboard_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_units_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/unit_model.dart';

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
  ResidentialNeighborhoodDashboardModel? _dashboardData;
  List<ResidentialNeighborhoodModel> _allNeighborhoods = [];
  ResidentialNeighborhoodUnitModel? _neighborhoodWithUnits;
  List<Unit> _allNeighborhoodUnits = [];

  Future<void> setResidentialNeighborhood(
    ResidentialNeighborhoodModel residentialNeighborhood,
  ) async {
    this.residentialNeighborhood = residentialNeighborhood;
  }

  void changeSelectedNeighborhoodManager(int? selectedResidentialManager) {
    selectedManager = selectedResidentialManager;
  }

  void changeResidentialNeighborhoodManager({
    required String identifier,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.post(
        ApiLink.changeResidentialNeighborhoodManager(
          neighborhoodId: residentialNeighborhood!.neighborhoodId,
        ),
        data: {
          'personId': selectedManager,
          'email': identifier,
          'password': password,
        },
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodUpdatedSuccessfully(
            message: response["message"],
          ),
        );
        await getResidentialNeighborhoodsDashboard();
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

  Future<void> getResidentialNeighborhoodsDashboard({String? search}) async {
    emit(ResidentialNeighborhoodsLoading());
    try {
      final response = await api.get(
        ApiLink.getAllResidentialNeighborhoodsDashboard,
      );

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      _dashboardData = ResidentialNeighborhoodDashboardModel.fromJson(
        response["data"],
      );
      _allNeighborhoods = _dashboardData!.neighborhoods;

      if (search != null && search.isNotEmpty) {
        filterNeighborhoods(search);
      }

      if (!isClosed) {
        emit(
          ResidentialNeighborhoodsLoaded(
            dashboardData: _dashboardData!,
            filteredNeighborhoods: _allNeighborhoods,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        ResidentialNeighborhoodsFailure(errorMessage: e.errModel.errorMessage),
      );
    } catch (e) {
      emit(ResidentialNeighborhoodsFailure(errorMessage: e.toString()));
    }
  }

  void filterNeighborhoods(String query) {
    if (_dashboardData == null) return;

    if (query.isEmpty) {
      emit(
        ResidentialNeighborhoodsLoaded(
          dashboardData: _dashboardData!,
          filteredNeighborhoods: _allNeighborhoods,
        ),
      );
      return;
    }
    final filteredList = _allNeighborhoods
        .where(
          (neighborhood) => neighborhood.neighborhoodName
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
    emit(
      ResidentialNeighborhoodsLoaded(
        dashboardData: _dashboardData!,
        filteredNeighborhoods: filteredList,
      ),
    );
  }

  Future<void> addNewNeighborhood(
    String name,
    String identifier,
    String password,
  ) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.post(
        ApiLink.addResidentialNeighborhood,
        data: {
          'name': name,
          'personId': selectedManager,
          'identifier': identifier,
          'password': password,
        },
      );

      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
        await getResidentialNeighborhoodsDashboard();
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

  Future<void> updateNeighborhood({required String name}) async {
    emit(WaitingForUpdateOrAddResidentialNeighborhood());
    try {
      final response = await api.update(
        '${ApiLink.updateResidentialNeighborhood}/${residentialNeighborhood!.neighborhoodId}',
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialNeighborhoodUpdatedSuccessfully(message: response["data"]),
        );
        await getResidentialNeighborhoodsDashboard();
      } else {
        final String errorMessage =
            response["message"] ?? "حدث خطأ غير معروف أثناء تحديث الحي";
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
        await getResidentialNeighborhoodsDashboard();
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

  Future<void> getResidentialNeighborhoodUnits(int id) async {
    emit(ResidentialNeighborhoodUnitsLoading());
    try {
      final response = await api.get(
        ApiLink.getResidentialNeighborhoodUnits(neighborhoodId: id),
      );

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      _neighborhoodWithUnits = ResidentialNeighborhoodUnitModel.fromJson(
        response["data"],
      );
      _allNeighborhoodUnits = _neighborhoodWithUnits!.residentialUnits;

      if (!isClosed) {
        emit(
          ResidentialNeighborhoodUnitssLoaded(
            neighborhoodWithUnits: _neighborhoodWithUnits!,
            allNeighborhoodUnits: _allNeighborhoodUnits,
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

  void filterNeighborhoodUnits(String query) {
    if (_neighborhoodWithUnits == null) return;

    if (query.isEmpty) {
      emit(
        ResidentialNeighborhoodUnitssLoaded(
          neighborhoodWithUnits: _neighborhoodWithUnits!,
          allNeighborhoodUnits: _allNeighborhoodUnits,
        ),
      );
      return;
    }
    final filteredList = _allNeighborhoodUnits
        .where((unit) => unit.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(
      ResidentialNeighborhoodUnitssLoaded(
        neighborhoodWithUnits: _neighborhoodWithUnits!,
        allNeighborhoodUnits: filteredList,
      ),
    );
  }

  // Future<void> getResidentialNeighborhoods({String? search}) async {
  //   emit(ResidentialNeighborhoodsLoading());
  //   try {
  //     final response = await api.get(ApiLink.getAllResidentialNeighborhoods);
  //     if (response["data"] == null) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: 400,
  //           errorMessage: "No data received",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     List<dynamic> neighborhoods = response["data"];
  //     _allNeighborhoods = neighborhoods
  //         .map((e) => ResidentialNeighborhoodModel.fromJson(e))
  //         .toList();
  //     if (search != null && search.isNotEmpty) {
  //       filterNeighborhoods(search);
  //     } else {
  //       if (!isClosed) {
  //         emit(
  //           ResidentialNeighborhoodsLoaded(
  //             allFilteredNeighborhoods: _allNeighborhoods,
  //             allResidentialNeighborhoods: _allNeighborhoods,
  //           ),
  //         );
  //       }
  //     }
  //   } on Serverexception catch (e) {
  //     emit(
  //       ResidentialNeighborhoodsFailure(errorMessage: e.errModel.errorMessage),
  //     );
  //   } catch (e) {
  //     emit(ResidentialNeighborhoodsFailure(errorMessage: e.toString()));
  //   }
  // }
}
