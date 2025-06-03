import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_neighborhod_app/models/family.dart';

import '../../../components/constants/api_link.dart';
import '../../../core/errors/exception.dart';
import 'dart:async';

import '../../core/API/dio_consumer.dart'; // لإستخدام TimeoutException

part 'residdential_blocksdential_state.dart';

class ResiddentialBlockDetailCubit extends Cubit<ResiddentialBlockDetailState> {
  final DioConsumer api;
  ResiddentialBlockDetailCubit({required this.api})
      : super(ResiddentialBlockDetailInitial());

  static ResiddentialBlockDetailCubit get(context) => BlocProvider.of(context);

  Future<void> get_AllBlockFamilys(int IdBlock) async {
    emit(get_AllBlockFamilys_Loading());
    try {
      final List<dynamic> response = await api
          .get(
            ApiLink.getAllBlockes,
          )
          .timeout(const Duration(seconds: 15)); // إضافة مهلة لمدة 15 ثانية
      List<Family> AllBlockFamilys =
          response.map((family) => Family.fromJson(family)).toList();
      emit(get_AllBlockFamilys_Success(AllBlockFamilys: AllBlockFamilys));
    } on TimeoutException catch (e) {
      emit(get_AllBlockFamilys_Failure(
          errorMessage: "Timeout: ${e.toString()}"));
    } on Serverexception catch (e) {
      emit(get_AllBlockFamilys_Failure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(get_AllBlockFamilys_Failure(errorMessage: e.toString()));
    }
  }
}
