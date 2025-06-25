import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/project_catgory.dart';

@immutable
abstract class ProjectCategoryState {}

class ProjectCategoryInitial extends ProjectCategoryState {}

class ProjectCategoryLoaded extends ProjectCategoryState {
  final List<ProjectCategory> projectCategories;

  ProjectCategoryLoaded({required this.projectCategories});
}

class ProjectCategoryLoading extends ProjectCategoryState {}

class ProjectCategoryFailure extends ProjectCategoryState {
  final String errorMessage;
  ProjectCategoryFailure({required this.errorMessage});
}
