import 'package:smart_negborhood_app/models/login_model.dart';

abstract class LoginState {}

class LoginIntial extends LoginState {}

class LoginSuccess extends LoginState {
  final UserData userdata;

  LoginSuccess(this.userdata);
}

class LoginLoading extends LoginState {}

class ChangePasswordVisibility extends LoginState {}

class LoginFailure extends LoginState {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}
