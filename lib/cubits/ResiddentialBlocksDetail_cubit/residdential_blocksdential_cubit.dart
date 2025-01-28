import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_neighborhod_app/models/family.dart';

import '../../../components/constants/api_link.dart';
import '../../../core/API/api_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../../models/Block.dart';

part 'residdential_blocksdential_state.dart';

class ResiddentialBlockDetailCubit extends Cubit<ResiddentialBlockDetailState> {
  ResiddentialBlockDetailCubit({required this.api})
      : super(ResiddentialBlockDetailInitial());
  static ResiddentialBlockDetailCubit get(context) => BlocProvider.of(context);

  ApiConsumer api;
  get_AllBlockFamilys(int IdBlock) async {
    emit(get_AllBlockFamilys_Loading());
    try {
      final List<dynamic> response = await api.get(
        ApiLink.getAllBlockFamilys("${IdBlock}"),
      );
      List<Family> AllBlockFamilys =
          response.map((family) => Family.fromJson(family)).toList();
      emit(get_AllBlockFamilys_Success(
          AllBlockFamilys: AllBlockFamilys));
    } on Serverexception catch (e) {
      emit(get_AllBlockFamilys_Failure(errorMessage: e.errModel.errorMessage));
    }
  }
}
