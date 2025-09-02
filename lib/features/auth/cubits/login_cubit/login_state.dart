import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';

abstract class LoginState {}

class LoginIntial extends LoginState {}

class LoginSuccess extends LoginState {
  final UserData userdata;
    final String message;

  LoginSuccess({required this.userdata,required this.message});
}

class LoginLoading extends LoginState {}

class ChangePasswordVisibility extends LoginState {}

class LoginFailure extends LoginState {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}
