part of 'residdential_blocksdential_cubit.dart';

@immutable
abstract class ResiddentialBlockDetailState {}

class ResiddentialBlockDetailInitial extends ResiddentialBlockDetailState {}

class get_AllBlockFamilys_Success extends ResiddentialBlockDetailState {
  final List<Family> AllBlockFamilys;

  get_AllBlockFamilys_Success({required this.AllBlockFamilys});
}

class get_AllBlockFamilys_Loading extends ResiddentialBlockDetailState {}

class get_AllBlockFamilys_Failure extends ResiddentialBlockDetailState {
  final String errorMessage;
  get_AllBlockFamilys_Failure({required this.errorMessage});
}
