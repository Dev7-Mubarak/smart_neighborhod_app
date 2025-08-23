part of 'main_home_cubit.dart';

@immutable
abstract class MainHomeState {}

class MainHomeInitial extends MainHomeState {}

class MainHomeIndexChanged extends MainHomeState {
  final int selectedIndex;
  MainHomeIndexChanged(this.selectedIndex);
}
