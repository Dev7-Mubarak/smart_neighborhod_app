import 'package:flutter/material.dart';
import '../../data/models/family_category.dart';

@immutable
abstract class FamilyCategoryState {}

class FamilyCategoryInitial extends FamilyCategoryState {}

class FamilyCategoryLoaded extends FamilyCategoryState {
  final List<FamilyCategory> familyCategories;

  FamilyCategoryLoaded({required this.familyCategories});
}

class FamilyCategoryLoading extends FamilyCategoryState {}

class FamilyCategoryFailure extends FamilyCategoryState {
  final String errorMessage;
  FamilyCategoryFailure({required this.errorMessage});
}
