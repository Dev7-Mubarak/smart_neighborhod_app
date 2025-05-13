import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/core/errors/errormodel.dart';
import 'package:smart_neighborhod_app/cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../../models/Block.dart';

class BlockCubit extends Cubit<BlockState> {
  BlockCubit({required this.api}) : super(BlockInitial());
  static BlockCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getBlocks() async {
    emit(BlocksLoading());
    try {
      final response = await api.get(
        ApiLink.getAllBlockes,
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
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
      String name, int? personId, String email, String password) async {
    emit(BlocksLoading());
    try {
      final response = await api.post(
        ApiLink.addBlocke,
        data: {
          'name': name,
          'personId': personId,
          'email': email,
          'password': password,
        },
      );

      if (response["isSuccess"]) {
        emit(BlockAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح"));
        await getBlocks();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            status: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
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
