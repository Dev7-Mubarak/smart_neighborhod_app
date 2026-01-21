import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/residential_units/data/models/unit_block_model.dart';

import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import '../../data/models/residential_unit_dashboard_model.dart';
import '../../data/models/residential_unit_model.dart';
import '../../data/models/residential_unit_blocks_model.dart';
import 'residential_units_state.dart';

class ResidentialUnitsCubit extends Cubit<ResidentialUnitsState> {
  ResidentialUnitsCubit({required this.api}) : super(ResidentialUnitsInitial());
  static ResidentialUnitsCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  ResidentialUnitModel? selectedUnit;
  ResidentialUnitDashboardModel? _dashboardData;
  List<ResidentialUnitModel> _allUnits = [];
  ResidentialUnitBlocksModel? _unitWithBlocks;
  List<UnitBlock> _allBlocks = [];

  int? selectedManager;
  int? selectedNeighborhoodId;

  void changeSelectedUnitManager(int? personId) {
    selectedManager = personId;
  }

  void changeSelectedNeighborhoodId(int? neighborhoodId) {
    selectedNeighborhoodId = neighborhoodId;
  }

  Future<void> getResidentialUnitBlocks(int unitId) async {
    emit(ResidentialUnitBlocksLoading());
    try {
      final response = await api.get(
        ApiLink.getResidentialUnitBlocks(unitId: unitId),
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

      _unitWithBlocks = ResidentialUnitBlocksModel.fromJson(response["data"]);
      _allBlocks = _unitWithBlocks!.blocks;

      if (!isClosed) {
        emit(
          ResidentialUnitBlocksLoaded(
            unitWithBlocks: _unitWithBlocks,
            allBlocks: _allBlocks,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(ResidentialUnitBlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ResidentialUnitBlocksFailure(errorMessage: e.toString()));
    }
  }

  void filterResidentialUnitBlocks(String query) {
    if (_unitWithBlocks == null) return;

    if (query.isEmpty) {
      emit(
        ResidentialUnitBlocksLoaded(
          unitWithBlocks: _unitWithBlocks,
          allBlocks: _allBlocks,
        ),
      );
      return;
    }
    final filteredList = _allBlocks
        .where((unit) => unit.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(
      ResidentialUnitBlocksLoaded(
        unitWithBlocks: _unitWithBlocks,
        allBlocks: filteredList,
      ),
    );
  }

  void setSelectedUnit(ResidentialUnitModel unit) {
    selectedUnit = unit;
  }

  Future<void> getResidentialUnitsDashboard({String? search}) async {
    emit(ResidentialUnitsLoading());
    try {
      final response = await api.get(ApiLink.getAllResidentialUnitsDashboard);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      _dashboardData = ResidentialUnitDashboardModel.fromJson(response["data"]);
      _allUnits = _dashboardData!.units;

      if (search != null && search.isNotEmpty) {
        filterUnits(search);
      }

      if (!isClosed) {
        emit(
          ResidentialUnitsLoaded(
            dashboardData: _dashboardData!,
            filteredUnits: _allUnits,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(ResidentialUnitsFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ResidentialUnitsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getResidentialUnitsMeDashboard({String? search}) async {
    emit(ResidentialUnitsLoading());
    try {
      final response = await api.get(ApiLink.getAllResidentialUnitsMeDashboard);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      _dashboardData = ResidentialUnitDashboardModel.fromJson(response["data"]);
      _allUnits = _dashboardData!.units;

      if (search != null && search.isNotEmpty) {
        filterUnits(search);
      }

      if (!isClosed) {
        emit(
          ResidentialUnitsLoaded(
            dashboardData: _dashboardData!,
            filteredUnits: _allUnits,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(ResidentialUnitsFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ResidentialUnitsFailure(errorMessage: e.toString()));
    }
  }

  void filterUnits(String query) {
    if (_dashboardData == null) return;
    if (query.isEmpty) {
      emit(
        ResidentialUnitsLoaded(
          dashboardData: _dashboardData!,
          filteredUnits: _allUnits,
        ),
      );
      return;
    }
    final filteredList = _allUnits
        .where((unit) => unit.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(
      ResidentialUnitsLoaded(
        dashboardData: _dashboardData!,
        filteredUnits: filteredList,
      ),
    );
  }

  Future<void> addNewUnit({
    required String name,
    required String identifier,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddResidentialUnit());
    try {
      if (selectedManager == null) {
        throw Exception("لا يمكن إنشاء وحدة سكنية من دون ان يكون لها مدير ");
      }
      if (selectedNeighborhoodId == null) {
        throw Exception("لا يمكن إنشاء وحدة سكنية من دون ان يكون لها حي سكني");
      }
      final response = await api.post(
        ApiLink.addResidentialUnit,
        data: {
          'name': name,
          'residentialNeighborhoodId': selectedNeighborhoodId,
          'personId': selectedManager,
          'identifier': identifier,
          'password': password,
        },
      );

      if (response["isSuccess"]) {
        emit(
          ResidentialUnitAddedSuccessfully(
            message: response["message"] ?? "Added",
          ),
        );
        // await getResidentialUnitsDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "Unknown error",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialUnit(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialUnit(errorMessage: e.toString()));
    }
  }

  Future<void> updateUnit({required String name}) async {
    emit(WaitingForUpdateOrAddResidentialUnit());
    try {
      final response = await api.update(
        '${ApiLink.updateResidentialUnit}/${selectedUnit?.id}',
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialUnitUpdatedSuccessfully(
            message: response["message"] ?? "Updated",
          ),
        );
        await getResidentialUnitsDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"],
            errorMessage: response["message"] ?? "Error while updating",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialUnit(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialUnit(errorMessage: e.toString()));
    }
  }

  Future<void> deleteUnit(int id) async {
    emit(WaitingForUpdateOrAddResidentialUnit());
    try {
      final response = await api.delete('${ApiLink.deleteResidentialUnit}/$id');
      if (response["isSuccess"]) {
        emit(
          ResidentialUnitDeletedSuccessfully(
            message: response["data"] ?? 'Deleted',
          ),
        );
        await getResidentialUnitsDashboard();
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
        FailureForUpdateOrAddResidentialUnit(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialUnit(errorMessage: e.toString()));
    }
  }

  Future<void> changeUnitManager({
    required String identifier,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddResidentialUnit());
    try {
      if (selectedManager == null) {
        throw Exception(
          "لا يمكن تغيير مدير الوحدة السكنية بدون تحديد مدير جديد ",
        );
      }
      final response = await api.update(
        ApiLink.changeResidentialUnitsManager(unitId: selectedUnit!.id),
        data: {
          'identifier': identifier,
          'password': password,
          'personId': selectedManager,
        },
      );
      if (response["isSuccess"]) {
        emit(ResidentialUnitUpdatedSuccessfully(message: response["message"]));
        await getResidentialUnitsDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "Unknown error",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialUnit(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialUnit(errorMessage: e.toString()));
    }
  }
}
