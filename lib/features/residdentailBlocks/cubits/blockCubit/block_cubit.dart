import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/cubits/blockCubit/block_state.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import '../../data/models/Block.dart';

class BlockCubit extends Cubit<BlockState> {
  BlockCubit({required this.api}) : super(BlockInitial());
  static BlockCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Block? block;
  int? selectedManager;

  Future<void> setBlock(Block block) async {
    this.block = block;
    this.selectedManager = block.personId;
  }

  void changeSelectedBlockManager(int? selectedBlockManager) {
    this.selectedManager = selectedBlockManager;
  }

  void changeBlockManager({
    required int id,
    required int personId,
    required String email,
    required String password,
  }) async {
    emit(WaitingForUpdateOrAddBlock());
    try {
      final response = await api.update(
        '${ApiLink.changeBlockManager}/$id/manager',
        data: {"email": email, "password": password, "personId": personId},
      );

      if (response["isSuccess"]) {
        emit(BlockUpdatedSuccessfully(message: response["message"]));
        await getBlocks();
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
      emit(FailureForUpdateOrAddBlock(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FailureForUpdateOrAddBlock(errorMessage: e.toString()));
    }
  }

  Future<void> getBlocks() async {
    emit(BlocksLoading());
    try {
      final response = await api.get(ApiLink.getAllBlockes);

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

      emit(BlocksLoaded(blocks.map((e) => Block.fromJson(e)).toList()));
    } on Serverexception catch (e) {
      emit(BlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(BlocksFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addNewBlock(String name, String email, String password) async {
    emit(WaitingForUpdateOrAddBlock());
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
          BlockAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
        await getBlocks();
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
      emit(FailureForUpdateOrAddBlock(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FailureForUpdateOrAddBlock(errorMessage: e.toString()));
    }
  }

  Future<void> updateBlock({required int id, required String name}) async {
    emit(WaitingForUpdateOrAddBlock());
    try {
      final response = await api.update(
        '${ApiLink.updateBlocke}/$id',
        data: {'name': name},
      );
      if (response["isSuccess"]) {
        emit(BlockUpdatedSuccessfully(message: response["message"]));
        await getBlocks();
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
      emit(FailureForUpdateOrAddBlock(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FailureForUpdateOrAddBlock(errorMessage: e.toString()));
    }
  }

  Future<void> deleteBlock(int id) async {
    emit(WaitingForUpdateOrAddBlock());
    try {
      final response = await api.delete('${ApiLink.deleteBlocke}/$id');

      if (response["isSuccess"]) {
        emit(
          BlockDeletedSuccessfully(
            message: response["message"] ?? 'تم الحذف بنجاح',
          ),
        );
        await getBlocks();
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
      emit(FailureForUpdateOrAddBlock(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FailureForUpdateOrAddBlock(errorMessage: e.toString()));
    }
  }
}
