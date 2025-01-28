import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../components/constants/api_link.dart';
import '../../../core/API/api_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../../models/Block.dart';

part 'residdential_blocks_state.dart';

class ResiddentialBlocksCubit extends Cubit<ResiddentialBlocksState> {
  ResiddentialBlocksCubit({required this.api}) : super(ResiddentialBlocksInitial());
  static ResiddentialBlocksCubit get(context) => BlocProvider.of(context);
  
  ApiConsumer api;
  get_ResiddentialBlocks() async {
      emit(get_ResiddentialBlocks_Loading());
    try {
      final List<dynamic> response = await api.get(
        ApiLink.getAllBlockes,
      );
      List<Block> allresiddentialblocks=response.map((block)=>Block.fromJson(block)).toList();
      emit(get_ResiddentialBlocks_Success(AllResiddentialBlocks: allresiddentialblocks));
    } on Serverexception catch (e) {
      emit(get_ResiddentialBlocks_Failure(errorMessage: e.errModel.errorMessage));
    }
  }

}

