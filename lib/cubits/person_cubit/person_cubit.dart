import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_neighborhod_app/core/errors/errormodel.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../models/Person.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  PersonCubit({required this.api}) : super(PersonInitial());
  static PersonCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getPeople() async {
    emit(PersonLoading());
    try {
      final response = await api.get(
        ApiLink.getAllPepole,
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
      }

      List<dynamic> people = response["data"];

      emit(PersonLoaded(
          people: people.map((e) => Person.fromJsonFor(e)).toList()));
    } on Serverexception catch (e) {
      emit(PersonFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(PersonFailure(errorMessage: e.toString()));
    }
  }
}
