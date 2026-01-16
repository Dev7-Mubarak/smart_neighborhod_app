import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/family_model.dart';
import '../../data/models/residential_block_dashboard_model.dart';
import '../../data/models/residential_block_families_model.dart';
import '../../data/models/residential_block_model.dart';

@immutable
abstract class ResidentialBlocksState {}

class ResidentialBlocksInitial extends ResidentialBlocksState {}

class ResidentialBlocksLoading extends ResidentialBlocksState {}

class ResidentialBlocksLoaded extends ResidentialBlocksState {
  final ResidentialBlockDashboardModel dashboardData;
  final List<ResidentialBlockModel> filteredBlocks;

  ResidentialBlocksLoaded({
    required this.dashboardData,
    required this.filteredBlocks,
  });
}

class ResidentialBlocksFailure extends ResidentialBlocksState {
  final String errorMessage;
  ResidentialBlocksFailure({required this.errorMessage});
}

class ResidentialBlockFamiliesLoaded extends ResidentialBlocksState {
  final ResidentialBlockFamiliesModel blockWithFamilies;
  final List<FamilyModel> allBlockFamilies;
  ResidentialBlockFamiliesLoaded({
    required this.blockWithFamilies,
    required this.allBlockFamilies,
  });
}

class ResidentialBlockFamiliesLoading extends ResidentialBlocksState {}

class WaitingForUpdateOrAddResidentialBlock extends ResidentialBlocksState {}

class ResidentialBlockAddedSuccessfully extends ResidentialBlocksState {
  final String message;
  ResidentialBlockAddedSuccessfully({required this.message});
}

class ResidentialBlockUpdatedSuccessfully extends ResidentialBlocksState {
  final String message;
  ResidentialBlockUpdatedSuccessfully({required this.message});
}

class ResidentialBlockDeletedSuccessfully extends ResidentialBlocksState {
  final String message;
  ResidentialBlockDeletedSuccessfully({required this.message});
}

class FailureForUpdateOrAddResidentialBlock extends ResidentialBlocksState {
  final String errorMessage;
  FailureForUpdateOrAddResidentialBlock({required this.errorMessage});
}
