import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_Dashboard_model.dart';

import '../../data/models/residential_neighborhood_model.dart';

@immutable
abstract class ResidentialNeighborhoodsState {}

class ResidentialNeighborhoodsInitial extends ResidentialNeighborhoodsState {}

class ResidentialNeighborhoodsLoaded extends ResidentialNeighborhoodsState {
  // final List<ResidentialNeighborhoodModel> allResidentialNeighborhoods;
  // final List<ResidentialNeighborhoodModel> allFilteredNeighborhoods;

  // ResidentialNeighborhoodsLoaded({
  //   required this.allFilteredNeighborhoods,
  //   required this.allResidentialNeighborhoods,
  // });
  final ResidentialNeighborhoodDashboardModel dashboardData;
  final List<ResidentialNeighborhoodModel> filteredNeighborhoods;

  ResidentialNeighborhoodsLoaded({
    required this.dashboardData,
    required this.filteredNeighborhoods,
  });
}

class ResidentialNeighborhoodsLoading extends ResidentialNeighborhoodsState {}

class ResidentialNeighborhoodsFailure extends ResidentialNeighborhoodsState {
  final String errorMessage;
  ResidentialNeighborhoodsFailure({required this.errorMessage});
}

class ResidentialNeighborhoodAddedSuccessfully
    extends ResidentialNeighborhoodsState {
  final String message;
  ResidentialNeighborhoodAddedSuccessfully({required this.message});
}

class ResidentialNeighborhoodDeletedSuccessfully
    extends ResidentialNeighborhoodsState {
  final String message;
  ResidentialNeighborhoodDeletedSuccessfully({required this.message});
}

class ResidentialNeighborhoodUpdatedSuccessfully
    extends ResidentialNeighborhoodsState {
  final String message;
  ResidentialNeighborhoodUpdatedSuccessfully({required this.message});
}

class WaitingForUpdateOrAddResidentialNeighborhood
    extends ResidentialNeighborhoodsState {}

class FailureForUpdateOrAddResidentialNeighborhood
    extends ResidentialNeighborhoodsState {
  final String errorMessage;
  FailureForUpdateOrAddResidentialNeighborhood({required this.errorMessage});
}

class ChangeSelectedManager extends ResidentialNeighborhoodsState {}
