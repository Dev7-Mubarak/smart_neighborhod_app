import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/family_model.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/residential_block_dashboard_model.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/residential_block_families_model.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/residential_block_model.dart';

import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import 'residential_blocks_state.dart';

class ResidentialBlocksCubit extends Cubit<ResidentialBlocksState> {
  ResidentialBlocksCubit({required this.api})
    : super(ResidentialBlocksInitial());
  static ResidentialBlocksCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  ResidentialBlockDashboardModel? _dashboardData;
  List<ResidentialBlockModel> _allBlocks = [];
  ResidentialBlockFamiliesModel? _blockWithFamilies;
  List<FamilyModel> _allBlockFamilies = [];
  int? selectedUnitId;
  ResidentialBlockModel? selectedBlock;
  int? selectedManager;
  void changeSelectedUnitId(int? selectedUnitId) {
    this.selectedUnitId = selectedUnitId;
  }

  void setSelectedBlock(ResidentialBlockModel block) {
    selectedBlock = block;
  }

  void changeSelectedBlockManager(int? selectedBlockManager) {
    selectedManager = selectedBlockManager;
  }

  Future<void> getResidentialBlocksDashboard({String? search}) async {
    emit(ResidentialBlocksLoading());
    try {
      final response = await api.get(ApiLink.getAllResidentialBlocksDashboard);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      _dashboardData = ResidentialBlockDashboardModel.fromJson(
        response["data"],
      );
      _allBlocks = _dashboardData!.blocks;

      if (search != null && search.isNotEmpty) {
        filterBlocks(search);
      } else {
        if (!isClosed) {
          emit(
            ResidentialBlocksLoaded(
              dashboardData: _dashboardData!,
              filteredBlocks: _allBlocks,
            ),
          );
        }
      }
    } on Serverexception catch (e) {
      emit(ResidentialBlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ResidentialBlocksFailure(errorMessage: e.toString()));
    }
  }

  void filterBlocks(String query) {
    if (_dashboardData == null) return;

    if (query.isEmpty) {
      emit(
        ResidentialBlocksLoaded(
          dashboardData: _dashboardData!,
          filteredBlocks: _allBlocks,
        ),
      );
      return;
    }

    final filteredList = _allBlocks
        .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(
      ResidentialBlocksLoaded(
        dashboardData: _dashboardData!,
        filteredBlocks: filteredList,
      ),
    );
  }

  Future<void> addNewBlock({
    required String name,
    required String identifier,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddResidentialBlock());
    try {
      final response = await api.post(
        ApiLink.addResidentialBlock,
        data: {
          'name': name,
          'personId': selectedManager,
          'identifier': identifier,
          'password': password,
          'resitinalUnitId': selectedUnitId,
        },
      );

      if (response["isSuccess"]) {
        emit(
          ResidentialBlockAddedSuccessfully(
            message: response["message"] ?? "Added",
          ),
        );
        await getResidentialBlocksDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "Unknown",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialBlock(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialBlock(errorMessage: e.toString()));
    }
  }

  Future<void> updateBlock({required int id, required String name}) async {
    emit(WaitingForUpdateOrAddResidentialBlock());
    try {
      final response = await api.update(
        '${ApiLink.updateResidentialBlock}/$id',
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialBlockUpdatedSuccessfully(
            message: response["message"] ?? "Updated",
          ),
        );
        await getResidentialBlocksDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "Unknown",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialBlock(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialBlock(errorMessage: e.toString()));
    }
  }

  Future<void> changeBlockManager({
    required String identifier,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddResidentialBlock());
    try {
      final response = await api.update(
        ApiLink.changeResidentialBlockManager(blockId: selectedBlock!.id),
        data: {
          'identifier': identifier,
          'password': password,
          'personId': selectedManager,
        },
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialBlockUpdatedSuccessfully(
            message: response["message"] ?? "Manager changed",
          ),
        );
        await getResidentialBlocksDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "Unknown",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialBlock(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialBlock(errorMessage: e.toString()));
    }
  }

  Future<void> deleteBlock(int id) async {
    emit(WaitingForUpdateOrAddResidentialBlock());
    try {
      final response = await api.delete(
        '${ApiLink.deleteResidentialBlock}/$id',
      );
      if (response["isSuccess"]) {
        emit(
          ResidentialBlockDeletedSuccessfully(
            message:
                response["data"]?.toString() ??
                response["message"] ??
                "Deleted",
          ),
        );
        await getResidentialBlocksDashboard();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "Unknown",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(
        FailureForUpdateOrAddResidentialBlock(
          errorMessage: e.errModel.errorMessage,
        ),
      );
    } catch (e) {
      emit(FailureForUpdateOrAddResidentialBlock(errorMessage: e.toString()));
    }
  }

  Future<void> getBlockFamilies(int id) async {
    emit(ResidentialBlockFamiliesLoading());
    try {
      final response = await api.get(
        ApiLink.getResidentialBlockFamilies(blockId: id),
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
      _blockWithFamilies = ResidentialBlockFamiliesModel.fromJson(
        response["data"],
      );
      _allBlockFamilies = _blockWithFamilies!.families;

      if (!isClosed) {
        emit(
          ResidentialBlockFamiliesLoaded(
            blockWithFamilies: _blockWithFamilies!,
            allBlockFamilies: _allBlockFamilies,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(ResidentialBlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ResidentialBlocksFailure(errorMessage: e.toString()));
    }
  }

  void filterBlockfamilies(String query) {
    if (_blockWithFamilies == null) return;

    if (query.isEmpty) {
      emit(
        ResidentialBlockFamiliesLoaded(
          blockWithFamilies: _blockWithFamilies!,
          allBlockFamilies: _allBlockFamilies,
        ),
      );
      return;
    }
    final filteredList = _allBlockFamilies
        .where(
          (family) => family.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    emit(
      ResidentialBlockFamiliesLoaded(
        blockWithFamilies: _blockWithFamilies!,
        allBlockFamilies: filteredList,
      ),
    );
  }
}
