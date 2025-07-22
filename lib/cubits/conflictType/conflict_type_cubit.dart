import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/models/conflict_type.dart';
import '../../components/constants/api_link.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../core/errors/exception.dart';
import 'conflict_type_state.dart';

class ConflictTypeCubit extends Cubit<ConflictTypeState> {
  ConflictTypeCubit({required this.api}) : super(ConflictTypeInitial());
  static ConflictTypeCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getConflictTypeCubit() async {
    emit(ConflictTypeLoading());
    try {
      final response = await api.get(ApiLink.getAllConfilctCaseTypes);
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
