import 'package:flutter/material.dart';
import '../../data/models/residential_unit_dashboard_model.dart';
import '../../data/models/residential_unit_summary_model.dart';

@immutable
abstract class ResidentialUnitsState {}

class ResidentialUnitsInitial extends ResidentialUnitsState {}

class ResidentialUnitsLoading extends ResidentialUnitsState {}

class ResidentialUnitsFailure extends ResidentialUnitsState {
  final String errorMessage;
  ResidentialUnitsFailure({required this.errorMessage});
}

class ResidentialUnitsLoaded extends ResidentialUnitsState {
  final ResidentialUnitDashboardModel dashboardData;
  final List<ResidentialUnitSummaryModel> filteredUnits;
  ResidentialUnitsLoaded({
    required this.dashboardData,
    required this.filteredUnits,
  });
}

class ResidentialUnitDetailsLoaded extends ResidentialUnitsState {
  final ResidentialUnitSummaryModel unit;
  ResidentialUnitDetailsLoaded({required this.unit});
}

class ResidentialUnitBlocksLoading extends ResidentialUnitsState {}

class ResidentialUnitBlocksLoaded extends ResidentialUnitsState {
  final dynamic unitWithBlocks;
  final List<dynamic> allBlocks;
  ResidentialUnitBlocksLoaded({required this.unitWithBlocks, required this.allBlocks});
}

class ResidentialUnitBlocksFailure extends ResidentialUnitsState {
  final String errorMessage;
  ResidentialUnitBlocksFailure({required this.errorMessage});
}

class WaitingForUpdateOrAddResidentialUnit extends ResidentialUnitsState {}

class ResidentialUnitAddedSuccessfully extends ResidentialUnitsState {
  final String message;
  ResidentialUnitAddedSuccessfully({required this.message});
}

class ResidentialUnitDeletedSuccessfully extends ResidentialUnitsState {
  final String message;
  ResidentialUnitDeletedSuccessfully({required this.message});
}

class ResidentialUnitUpdatedSuccessfully extends ResidentialUnitsState {
  final String message;
  ResidentialUnitUpdatedSuccessfully({required this.message});
}

class FailureForUpdateOrAddResidentialUnit extends ResidentialUnitsState {
  final String errorMessage;
  FailureForUpdateOrAddResidentialUnit({required this.errorMessage});
}
