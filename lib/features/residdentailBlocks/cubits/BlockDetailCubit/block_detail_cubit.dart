import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../data/models/BlockDetails.dart';
import 'block_detail_state.dart';
import '../../../residdentailBlocks/data/models/Block.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/errors/exception.dart';

class BlockDetailCubit extends Cubit<BlockDetailState> {
  final DioConsumer api;
  Block? blockDetail;

  BlockDetailCubit({required this.api}) : super(BlockDetailInitial());

  Future<void> getBlockDetailes(int blockId) async {
    emit(BlockDetailLoading());
    try {
      final response = await api.get(
        ApiLink.getBlockDetails,
        queryparameters: {'blockId': blockId},
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

      emit(BlockDetailLoaded(BlockDetails.fromJson(response["data"])));
    } on Serverexception catch (e) {
      emit(BlockDetailFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(BlockDetailFailure(errorMessage: e.toString()));
    }
  }
}
