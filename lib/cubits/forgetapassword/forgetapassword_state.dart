part of 'forgetapassword_cubit.dart';

@immutable
abstract class ForgetapasswordState {}

 class SendEmailInitial extends ForgetapasswordState {}

 class  SendEmailSuccess extends ForgetapasswordState {
  final String message;
  SendEmailSuccess(this.message);
}
class  SendEmailLoading extends ForgetapasswordState {}

class  SendEmailFailure extends ForgetapasswordState {
  String errorMessage;
  SendEmailFailure({required this.errorMessage});
}


 class  SendConfirmationCodeSuccess extends ForgetapasswordState {
  final String message;
  SendConfirmationCodeSuccess(this.message);
}
class  SendConfirmationCodeLoading extends ForgetapasswordState {}

class  SendConfirmationCodeFailure extends ForgetapasswordState {
  String errorMessage;
  SendConfirmationCodeFailure({required this.errorMessage});
}

 class  SendNewPasswordSuccess extends ForgetapasswordState {
  final String message;
  SendNewPasswordSuccess(this.message);
}
class  SendNewPasswordLoading extends ForgetapasswordState {}

class  SendNewPasswordFailure extends ForgetapasswordState {
  String errorMessage;
  SendNewPasswordFailure({required this.errorMessage});
}
class ChangeFirstPasswordVisibility extends ForgetapasswordState {}
class ChangeSecondPasswordVisibility extends ForgetapasswordState {}
