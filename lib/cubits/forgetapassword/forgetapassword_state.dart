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
