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
  ResiddentialBlocksCubit({required this.api})
      : super(ResiddentialBlocksInitial());
  static ResiddentialBlocksCubit get(context) => BlocProvider.of(context);

  ApiConsumer api;
  get_ResiddentialBlocks() async {
   emit(get_ResiddentialBlocks_Loading());
    try {
      final response = await Dio().get("https://smartnieborhoodapi.runasp.net/api/Blocks/GetAll");
      print(response.data); // طباعة البيانات لمعرفة الهيكل

      // تحقق من أن البيانات هي Map وليس List
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;

        // استخراج القائمة من الخريطة
        final List<dynamic> blocksList = data['data']; // استخراج القائمة من 'data'

        // تحويل القائمة إلى List<Block>
        List<Block> allResidentialBlocks = blocksList
            .map((block) => Block.fromJson(block))
            .toList();

      emit(get_ResiddentialBlocks_Success(AllResiddentialBlocks:allResidentialBlocks));
      } else {
        throw Exception("Expected a Map but got ${response.data.runtimeType}");
      }
    } catch (e) {
      print(e.toString());
      emit(get_ResiddentialBlocks_Failure(errorMessage: e.toString()));
    }
    // emit(get_ResiddentialBlocks_Loading());
    // try {
    //   final  response = await Dio().get("https://smartnieborhoodapi.runasp.net/api/Blocks/GetAll");
    //   print(response.data);
    //   List<Block> allresiddentialblocks =
    //       (response.data as List).map((block) => Block.fromJson(block)).toList();
    //   emit(get_ResiddentialBlocks_Success(AllResiddentialBlocks: allresiddentialblocks));
    // } catch (e) {
    //   print(e.toString());
    //         emit(get_ResiddentialBlocks_Failure( errorMessage: e.toString()));
    // }
    //   emit(get_ResiddentialBlocks_Loading());
    // try {
    //   final List<dynamic> response = await api.get(
    //     ApiLink.getAllBlockes,
    //   );
    //   List<Block> allresiddentialblocks=response.map((block)=>Block.fromJson(block)).toList();
    //   emit(get_ResiddentialBlocks_Success(AllResiddentialBlocks: allresiddentialblocks));
    // } on Serverexception catch (e) {
    //   emit(get_ResiddentialBlocks_Failure(errorMessage: e.errModel.errorMessage));
    // }
  }
}
