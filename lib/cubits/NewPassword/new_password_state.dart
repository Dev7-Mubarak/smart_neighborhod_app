part of 'new_password_cubit.dart';

@immutable
abstract class NewPasswordState {}

 class NewPasswordInitial extends NewPasswordState {}

// class LoginSuccess extends LoginState {
//   final LoginModel loginModel;

//   LoginSuccess(this.loginModel);
// }

// class LoginLoading extends LoginState {}

class ChangeFirstPasswordVisibility extends NewPasswordState {}
class ChangeSecondPasswordVisibility extends NewPasswordState {}

// class LoginFailure extends LoginState {
//   String errorMessage;
//   LoginFailure({required this.errorMessage});
// }
