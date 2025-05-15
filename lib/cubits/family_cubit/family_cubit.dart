import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_state.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/errors/exception.dart';
import 'dart:async';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../models/family.dart';
import '../../models/family_detiles_model.dart';
// لإستخدام TimeoutException

class FamilyCubit extends Cubit<FamilyState> {
  final DioConsumer api;
  FamilyCubit({required this.api}) : super(FamilyInitial());

  static FamilyCubit get(context) => BlocProvider.of(context);

  int _currentPage = 1;
  bool hasNextPage = true;
  List<Family> allFamilies = [];
  late int blockId;

  Future<void> getBlockFamiliesByBlockId(int blockIdPar) async {
    blockId = blockIdPar;
    if (!hasNextPage) return;

    emit(FamilyLoading());
    try {
      final response = await api.get(
        ApiLink.getBlockFamiliesById,
        queryparameters: {
          'blockId': blockId,
          'pageNumber': _currentPage,
          'pageSize': 10,
        },
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
      }

      List<dynamic> familes = response["data"]["items"];
      List<Family> newFamilies =
          familes.map((e) => Family.fromJson(e)).toList();

      allFamilies.addAll(newFamilies);

      _currentPage++;
      hasNextPage = response["data"]["hasNextPage"];
      emit(FamilyLoaded(families: allFamilies, hasNextPage: hasNextPage));
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addNewFamily(Family family, int? personId) async {
    emit(FamilyInitial());
    try {
      final response = await api.post(
        ApiLink.addFamily,
        data: {
          "name": family.name,
          "familyCatgoryId": family.familyCatgoryId,
          "location": family.location,
          "familyTypeId": family.familyTypeId,
          "familyNotes": family.familyNotes,
          "blockId": family.blockId,
          "personId": personId
        },
      );

      if (response["isSuccess"]) {
        emit(FamilyAddedSuccessfully(message: response["message"]));
        await getBlockFamiliesByBlockId(blockId);
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            status: response["statusCode"] ?? 400,
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFamilyDetilesById(int familyId) async {
    emit(FamilyInitial());
    try {
      final response = await api.get(
        '${ApiLink.getFamilyDetilesById}/$familyId',
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
      }
      emit(FamilyDetilesLoaded(
          familyDetiles: FamilyDetilesModel.fromJson(response["data"])));
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }
}
