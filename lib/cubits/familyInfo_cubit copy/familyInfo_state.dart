part of 'familyInfo_cubit.dart';

@immutable
abstract class familyInfoState {}

class familyInfoInitial extends familyInfoState {}

class get_Assists_Success extends familyInfoState {
  
  final List<Assist> Assists;
  get_Assists_Success({required this.Assists});

}
class get_Assists_Loading extends familyInfoState {}

class get_Assists_Failure extends familyInfoState {
    String errorMessage;
  get_Assists_Failure({required this.errorMessage});
}
