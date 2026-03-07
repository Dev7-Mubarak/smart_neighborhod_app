import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/statistics/data/models/statistics_model.dart';

@immutable
abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsFailure extends StatisticsState {
  final String errorMessage;
  StatisticsFailure({required this.errorMessage});
}

class StatisticsEmpty extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final StatisticsModel statisticsModel;
  StatisticsLoaded({required this.statisticsModel});
}
