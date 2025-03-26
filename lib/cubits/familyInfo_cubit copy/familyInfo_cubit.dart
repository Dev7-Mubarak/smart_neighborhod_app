import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_neighborhod_app/models/family.dart';

import '../../../components/constants/api_link.dart';
import '../../../core/API/api_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../../models/Block.dart';
import 'dart:async';

import '../../core/API/dio_consumer.dart';
import '../../models/Assist.dart'; // لإستخدام TimeoutException

part 'familyInfo_state.dart';

class familyInfoCubit extends Cubit<familyInfoState> {
  final DioConsumer api;
  familyInfoCubit({required this.api}) : super(familyInfoInitial());

  static familyInfoCubit get(context) => BlocProvider.of(context);

  Future<void> get_Assists(int Idfamily) async {
    emit(get_Assists_Loading());
    try {
      final List<dynamic> response = await api
          .get(ApiLink.getAssistsFamily("$Idfamily"))
          .timeout(const Duration(seconds: 15)); // إضافة مهلة لمدة 15 ثانية
      List<Assist> Assists =
          response.map((assist) => Assist.fromJson(assist)).toList();
      emit(get_Assists_Success(Assists: Assists));
    } on TimeoutException catch (e) {
      emit(get_Assists_Failure(errorMessage: "Timeout: ${e.toString()}"));
    } on Serverexception catch (e) {
      emit(get_Assists_Failure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(get_Assists_Failure(errorMessage: e.toString()));
    }
  }
}
