import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict_type.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import 'conflict_type_state.dart';

class ConflictTypeCubit extends Cubit<ConflictTypeState> {
  ConflictTypeCubit({required this.api}) : super(ConflictTypeInitial());
  static ConflictTypeCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getConflictTypeCubit() async {
    emit(ConflictTypeLoading());
    try {
      final response = await api.get(ApiLink.getAllConflictCaseTypes);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> conflictTypes = response["data"];

      emit(
        ConflictTypeLoaded(
          conflictTypes: conflictTypes
              .map((e) => ConflictType.fromJson(e))
              .toList(),
        ),
      );
    } on Serverexception catch (e) {
      emit(ConflictTypeFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ConflictTypeFailure(errorMessage: e.toString()));
    }
  }
}
