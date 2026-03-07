import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/statistics/data/models/statistics_model.dart';

import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/errors/exception.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required this.api}) : super(StatisticsInitial());
  static StatisticsCubit get(context) => BlocProvider.of(context);

  DioConsumer api;

  Future<void> getStatistics() async {
    emit(StatisticsLoading());
    try {
      final response = await api.get(ApiLink.getStatistics);
      dynamic respData = response["data"];
      if (respData == null) {
        if (!isClosed) emit(StatisticsEmpty());
        return;
      }

      if (respData is String) {
        try {
          final decoded = jsonDecode(respData);
          respData = decoded;
        } catch (_) {
          if (!isClosed) emit(StatisticsFailure(errorMessage: respData));
          return;
        }
      }

      if (respData is List && respData.isNotEmpty) {
        final first = respData.first;
        if (first is Map<String, dynamic>) {
          respData = first;
        }
      }

      if (respData is! Map<String, dynamic>) {
        if (!isClosed)
          emit(StatisticsFailure(errorMessage: 'Unexpected data format'));
        return;
      }

      if (!isClosed) {
        emit(
          StatisticsLoaded(statisticsModel: StatisticsModel.fromJson(respData)),
        );
      }
    } on Serverexception catch (e) {
      if (e.errModel.statusCode == 404) {
        emit(StatisticsEmpty());
      } else {
        emit(StatisticsFailure(errorMessage: e.errModel.errorMessage));
      }
    } catch (e) {
      if (e.toString().contains('404')) {
        emit(StatisticsEmpty());
      } else {
        emit(StatisticsFailure(errorMessage: e.toString()));
      }
    }
  }

  // Future<void> getStatistics() async {
  //   emit(StatisticsLoading());
  //   // --- بداية كود البيانات الوهمية (مؤقت للعرض فقط) ---
  //   await Future.delayed(const Duration(seconds: 1)); // محاكاة وقت التحميل
  //   try {
  //     // نقوم بإنشاء خريطة بيانات (JSON) يدوياً لمحاكاة استجابة السيرفر
  //     final mockData = {
  //       'socialAndFamily': {
  //         'divorced': 45,
  //         'widows': 32,
  //         'families': 150,
  //         'individuals': 600,
  //       },
  //       'agreements': {
  //         'completed': 80,
  //         'notCompleted': 20,
  //         'peaceCompleted': 30,
  //         'peaceNotCompleted': 5,
  //         'treatiesCompleted': 15,
  //         'treatiesNotCompleted': 2,
  //         'agreementsCompleted': 35,
  //         'agreementsNotCompleted': 13,
  //       },
  //       'projects': {'completed': 12, 'incomplete': 4},
  //       'teams': {'teamsCount': 8},
  //       'populationStatus': {'residents': 5000, 'displaced': 1200},
  //       'incomeCategories': {
  //         'categoryA': 200, // دخل مرتفع
  //         'categoryB': 500, // دخل متوسط
  //         'categoryC': 300, // دخل محدود
  //       },
  //       'health': {'individualsWithChronicDiseases': 145},
  //       'housing': {'rented': 320, 'owned': 450},
  //     };
  //     // تحويل البيانات الوهمية إلى الموديل وعرضها
  //     if (!isClosed) {
  //       emit(
  //         StatisticsLoaded(statisticsModel: StatisticsModel.fromJson(mockData)),
  //       );
  //     }
  //     // --- نهاية كود البيانات الوهمية ---
  //     /* // الكود الأصلي (قم بإلغاء التعليق عنه عندما تعمل الـ API)
  //     final response = await api.get(ApiLink.getStatistics);
  //     if (response["data"] == null) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: 400,
  //           errorMessage: "No data received",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     if (!isClosed) {
  //       emit(StatisticsLoaded(statisticsModel: StatisticsModel.fromJson(response["data"])));
  //     }
  //     */
  //   } catch (e) {
  //     emit(StatisticsFailure(errorMessage: e.toString()));
  //   }
  // }
}
