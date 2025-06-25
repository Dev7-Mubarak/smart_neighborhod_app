import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/errors/errormodel.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import 'package:smart_negborhood_app/models/Person.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../../models/Block.dart';

class BlockCubit extends Cubit<BlockState> {
  BlockCubit({required this.api}) : super(BlockInitial());
  static BlockCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Block? block;
  Person? selectedManager;

  Future<void> setBlockForUpdate(Block block) async {
    this.block = block;

    // convert this to service and repositry then called
    final response = await api.get(
      '${ApiLink.getPersonById}/${block.personId}',
    );

    if (response["data"] != null) {
      selectedManager = Person.fromJson(response["data"]);
    }
    //
  }

  void changeSelectedManager(Person? selectedManager) {
    this.selectedManager = selectedManager;
    emit(ChangeSelectedManager());
  }

  Future<void> getBlocks() async {
    emit(BlocksLoading());
    try {
      final response = await api.get(ApiLink.getAllBlockes);

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
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

  Future<void> addNewBlock(
    String name,
    String userName,
    String password,
  ) async {
    emit(BlocksLoading());
    try {
      final response = await api.post(
        ApiLink.addBlocke,
        data: {
          'name': name,
          'personId': selectedManager?.id,
          'userName': userName,
          'password': password,
        },
      );

      if (response["isSuccess"]) {
        emit(
          BlockAddedSuccessfully(
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
      emit(BlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(BlocksFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateBlock({
    required int id,
    required String name,
    required String userName,
  }) async {
    emit(BlocksLoading());
    try {
      final response = await api.update(
        '${ApiLink.updateBlocke}/$id',
        data: {
          'name': name,
          'personId': selectedManager?.id,
          'userName': userName,
        },
      );
      if (response["isSuccess"]) {
        emit(
          BlockUpdatedSuccessfully(
            message: response["message"] ?? "تم التحديث بنجاح",
          ),
        );
        await getBlocks();
      } else {
        final String errorMessage =
            response["message"] ?? "حدث خطأ غير معروف أثناء تحديث البلوك";
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"]?.toString() ?? '400',
            errorMessage: errorMessage,
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(BlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(BlocksFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteBlock(int id) async {
    emit(BlocksLoading());
    try {
      final response = await api.delete('${ApiLink.deleteBlocke}/$id');

      if (response["isSuccess"]) {
        emit(BlockDeletedSuccessfully(message: response["message"]));
        await getBlocks();
      } else {
        Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"]?.toString() ?? '400',
            errorMessage: response["message"],
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(BlocksFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(BlocksFailure(errorMessage: e.toString()));
    }
  }
}
