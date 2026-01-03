import 'package:flutter/material.dart';

import '../../data/models/residential_neighborhood_model.dart';

@immutable
abstract class ResidentialNeighborhoodsState {}

class ResidentialNeighborhoodsInitial extends ResidentialNeighborhoodsState {}

class ResidentialNeighborhoodsLoaded extends ResidentialNeighborhoodsState {
  final List<ResidentialNeighborhoodModel> allResidentialNeighborhoods;

  ResidentialNeighborhoodsLoaded(this.allResidentialNeighborhoods);
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
